# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nfe/signer/version'

Gem::Specification.new do |spec|
  spec.name          = "nfe-signer"
  spec.version       = Nfe::Signer::VERSION
  spec.authors       = ["Ronaldo de Sousa Araujo"]
  spec.email         = ["contato@ronaldoaraujo.eti.br"]

  spec.summary       = "Assinador para Nota Fiscal Eletronica"
  spec.description   = "Gem criada para interagir com o sistema de notas fiscais eletronicas do governo brasileiro"
  spec.homepage      = "http://www.nfegeral.com.br"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri", "~> 1.7"  
  spec.add_development_dependency "openssl", "~> 2.0"  
end