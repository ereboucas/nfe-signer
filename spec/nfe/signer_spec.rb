require "openssl"
require "spec_helper"

describe Nfe::Signer do
  it "has a version number" do
    expect(Nfe::Signer::VERSION).not_to be nil
  end

  it "has a valid sign" do

    fixtures_path = File.expand_path('../fixtures', __FILE__)
    key = OpenSSL::PKey::RSA.new(File.read("#{fixtures_path}/key.pem"))
    cert = OpenSSL::X509::Certificate.new(File.read("#{fixtures_path}/cert.pem"))
    signature_value = "L2l4qEb/rZ9Lg3zY8PqfmjQmGLLx/P02ALSbyqadt2UfHy5LoBpajkyiTHj7MgXlXVWOPI8Afi2djZIy5OmQMVeB7hA/NQzr5h7G7sxFE93hE/OqFA+u6kTeLeC34vFNWon0brBl40v1OlqNNUqmoDMuObYKy0YRppEJvW59Ooc="

    doc = File.open("#{fixtures_path}/nfe.xml") { |f| Nfe::Signer(f) }
    doc.sign!(key, cert)
    doc.remove_namespaces!

    expect(signature_value).to eq(doc.at_css("SignatureValue").content)
  end
end