NFe Signer
==========

[![Build Status](https://travis-ci.org/nfegeral/nfe-signer.svg?branch=master)](https://travis-ci.org/nfegeral/nfe-signer)

Assinador de Nota Fiscal Eletronica em ruby.

Versões suportadas
------------------

* Ruby 1.9.3
* Ruby 2.0.x
* Ruby 2.3.x
* Ruby 2.4.0

Install
-------

Se você estiver usando o `Bundler`, basta colocar essa linha no seu Gemfile:

```ruby
gem 'ruby_marks'
```

Em seguida, execute o comando bundle install:
    
    bundle

Caso contrário, você ainda pode executar um método de instalação padrão de gem:
    
    gem install nfe-signer

Exemplo de Uso
--------------

Primeiro você deve obter a chave privada e o certificado:

```ruby
key = OpenSSL::PKey::RSA.new(File.read("key.pem"))
cert = OpenSSL::X509::Certificate.new(File.read("cert.pem"))
```

Para carregar o xml a partir de um arquivo:

```ruby
doc = File.open("Nfe.xml") { |f| Nfe::Signer(f) }
```

Para carregar o xml a partir de uma string:

```ruby
xml = %{
  <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
    <infNFe Id='NFe35170101508376000174550010000000011000203062" versao="3.10">
    ...
    </infNFe>
  </NFe>  
}

doc = Nfe::Signer(xml)
```

Para Assinar basta chamar o método sign! passando a chave privada e o certificado.
Para obter a string com o xml assinado basta executar o metódo to_xml.

```ruby
doc.sign!(key, cert)
doc.to_xml
```

## Contribuidores

* Ronaldo de Sousa Araujo ([ronaldoaraujo](https://github.com/ronaldoaraujo))
* Lucas Augusto Correa ([correalucas](https://github.com/correalucas))

== Copyright

Copyright (c) 2017 NFeGeral. Leia LICENSE para mais detalhes.