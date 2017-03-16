module Bitmovin::Encoding::Outputs
  class GcsOutput < Bitmovin::Resource
    init 'encoding/outputs/gcs'
    attr_accessor :id, :name, :description, :created_at, :modified_at, :bucket_name, :cloud_region
  end
end
