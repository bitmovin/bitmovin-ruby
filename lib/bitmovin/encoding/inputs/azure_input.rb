module Bitmovin::Encoding::Inputs
  class AzureInput < Bitmovin::Resource
    init 'encoding/inputs/azure'
    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :account_name, :account_key
    attr_accessor :container
  end
end
