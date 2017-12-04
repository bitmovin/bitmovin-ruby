# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitmovin/version'

Gem::Specification.new do |spec|
  spec.name          = "bitmovin-ruby"
  spec.version       = Bitmovin::VERSION
  spec.authors       = ["Daniel Hoelbling-Inzko"]
  spec.email         = ["daniel.hoelbling-inzko@bitmovin.com"]

  spec.summary       = %q{Api Client for the Bitmovin API}
  spec.description   = %q{Provides full access to the Bitmovin API (http://https://bitmovin.com/encoding-documentation/bitmovin-api/)}
  spec.homepage      = "https://github.com/bitmovin/bitmovin-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|examples)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.11.0"
  spec.add_dependency "httpclient", "~> 2.8.3", ">= 2.8.3"
  spec.add_dependency "activesupport", ">= 4.0.0"
  spec.add_dependency "faraday_middleware", "~> 0.11.0"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
