require 'rubygems'
require 'bundler/setup'
require 'bitmovin/version'
require 'bitmovin/client'
require 'bitmovin/encoding'
require 'faraday'

module Bitmovin
  @@client = nil

  def self.init(api_key)
    @@client = Client.new({ api_key: api_key })
  end

  def self.client
    @@client
  end
end
