module Bitmovin::Encoding::Inputs
  class GenericS3Input < Bitmovin::Resource
    init 'encoding/inputs/generic-s3'
    attr_accessor :id, :created_at, :modified_at, :name, :description, :cloud_region, :bucket_name, :host, :port
    attr_accessor :secret_key, :access_key
  end
end
