require "nokogiri"
require "nfe/signer/version"
require "nfe/signer/signature"

module Nfe

  class << self

    def Signer(thing)
      Nokogiri::XML::Document.parse(thing, nil, "utf-8", Nokogiri::XML::ParseOptions::NOBLANKS)
    end
  end

  class Nokogiri::XML::Document

    def sign!(cert, key)
      Nfe::Signer::Signature.new(self, cert, key)
      self
    end
  end
end