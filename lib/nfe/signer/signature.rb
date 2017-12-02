require "base64"

module Nfe
  module Signer
    class Signature
      attr_accessor :document, :key, :cert

      def initialize(document, key, cert)
        @document = document
        @key  = key
        @cert = cert
        document.root.add_child signature
      end

      def signature
        # Create Signature
        node = Nokogiri::XML::Node.new('Signature', @document)
        node.default_namespace = 'http://www.w3.org/2000/09/xmldsig#'
        node.add_child signature_info
        node.add_child signature_value
        node.add_child key_info
        node
      end

      def signature_info
        # Create SignatureInfo
        signature_info_node = Nokogiri::XML::Node.new('SignedInfo', @document)

        # Add CanonicalizationMethod
        child_node = Nokogiri::XML::Node.new('CanonicalizationMethod', @document)
        child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
        signature_info_node.add_child child_node

        # Add SignatureMethod
        child_node = Nokogiri::XML::Node.new('SignatureMethod', @document)
        child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
        signature_info_node.add_child child_node

        # Add Reference
        signature_info_node.add_child reference
        signature_info_node
      end

      def signature_value
        # Sign Signature
        xml = Nokogiri::XML(signature_info.to_xml, &:noblanks)
        xml.root["xmlns"] = 'http://www.w3.org/2000/09/xmldsig#'
        sign_canon = xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
        signature_hash = @key.sign(OpenSSL::Digest::SHA1.new, sign_canon)

        # Add SignatureValue
        node = Nokogiri::XML::Node.new('SignatureValue', @document)
        node.content = Base64.encode64(signature_hash).gsub("\n", '')
        node
      end

      def key_info
        # Create KeyInfo
        node = Nokogiri::XML::Node.new('KeyInfo', @document)
        
        # Add X509 Data and Certificate
        x509_data = Nokogiri::XML::Node.new('X509Data', @document)
        x509_certificate = Nokogiri::XML::Node.new('X509Certificate', @document)
        x509_certificate.content = @cert.to_pem.gsub(/\-\-\-\-\-[A-Z]+ CERTIFICATE\-\-\-\-\-/, "").gsub(/\n/,"")

        x509_data.add_child x509_certificate
        node.add_child x509_data
        node
      end

      def reference
        inf = @document.at_xpath("//*[@Id]")

        # Calculate digest
        xml_canon = inf.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
        xml_digest = Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon)).strip

        # Create Reference
        node = Nokogiri::XML::Node.new('Reference', @document)
        node['URI'] = "##{inf['Id']}"
        node.add_child transforms

        # Add Digest
        child_node  = Nokogiri::XML::Node.new('DigestMethod', @document)
        child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#sha1'
        node.add_child child_node
        
        # Add DigestValue
        child_node  = Nokogiri::XML::Node.new('DigestValue', @document)
        child_node.content = xml_digest
        node.add_child child_node        
        node
      end

      def transforms
        # Add Transforms
        node = Nokogiri::XML::Node.new('Transforms', @document)

        # Add Transform
        child_node  = Nokogiri::XML::Node.new('Transform', @document)
        child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
        node.add_child child_node

        # Add Transform
        child_node  = Nokogiri::XML::Node.new('Transform', @document)
        child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
        node.add_child child_node
        node
      end

    end
  end
end