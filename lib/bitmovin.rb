require 'rubygems'
require 'bundler/setup'
require 'bitmovin/version'
require 'bitmovin/helpers'
require 'bitmovin/resource'
require 'bitmovin/client'
require 'bitmovin/encoding'
require 'faraday'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/inflector'

module Bitmovin
  @@client = nil

  def self.init(api_key)
    @@client = Client.new({ api_key: api_key })
  end

  def self.client
    @@client
  end
end
