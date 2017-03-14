module Bitmovin::Encoding::Inputs
  class AsperaInput < Bitmovin::Resource
    init 'encoding/inputs/aspera'
    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :host, :username, :password, :min_bandwith, :max_bandwith
  end
end
