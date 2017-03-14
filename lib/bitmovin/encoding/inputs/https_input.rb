module Bitmovin::Encoding::Inputs
  class HttpsInput < Bitmovin::Resource
    init 'encoding/inputs/https'
    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :host, :username, :password, :port
  end
end
