module Bitmovin::Encoding::Inputs
  class GcsInput < Bitmovin::Resource
    init 'encoding/inputs/gcs'
    attr_accessor :id, :created_at, :modified_at, :name, :description, :cloud_region, :bucket_name
    attr_accessor :secret_key, :access_key
  end
end
