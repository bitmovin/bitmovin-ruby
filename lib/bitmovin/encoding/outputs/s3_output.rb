module Bitmovin::Encoding::Outputs
  class S3Output < Bitmovin::Resource
    init 'encoding/outputs/s3'
    attr_accessor :id, :name, :description, :created_at, :modified_at, :bucket_name, :cloud_region
  end
end
