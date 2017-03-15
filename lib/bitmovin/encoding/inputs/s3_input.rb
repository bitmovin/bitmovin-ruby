module Bitmovin::Encoding::Inputs
  class S3Input < Bitmovin::InputResource
    init 'encoding/inputs/s3'
    attr_accessor :id, :created_at, :modified_at, :name, :description, :cloud_region, :bucket_name
    attr_accessor :secret_key, :access_key
  end
end
