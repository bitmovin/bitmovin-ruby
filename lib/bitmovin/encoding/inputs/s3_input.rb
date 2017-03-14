module Bitmovin::Encoding::Inputs
  class S3Input < Bitmovin::Resource
    self.resource_path 'encoding/inputs/s3'
    attr_accessor :id, :created_at, :modified_at, :name, :description, :cloud_region, :bucket_name
  end
end
