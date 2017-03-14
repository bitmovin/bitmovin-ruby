module Bitmovin::Encoding::Inputs
  class HttpInput < Bitmovin::Resource
    init 'encoding/inputs/http'
    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :host, :username, :password, :port
  end
end
