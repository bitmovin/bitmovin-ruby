require "spec_helper"

s3_list_response = response_envelope({
  items: [{
    id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
    type: 'S3',
    name: 's3 output',
    description: 'desc',
    bucketName: 'bucket',
    cloudRegion: 'EU_CENTRAL_1'
  }]
})
s3_detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 's3 output',
  description: 'desc',
  bucketName: 'bucket',
  cloudRegion: 'EU_CENTRAL_1'
})
s3_detail_response = response_envelope(s3_detail)

test_resource_methods(Bitmovin::Encoding::Outputs::S3Output, "/v1/encoding/outputs/s3", {
  list: s3_list_response, 
  detail: s3_detail_response,
  item: s3_detail
})
