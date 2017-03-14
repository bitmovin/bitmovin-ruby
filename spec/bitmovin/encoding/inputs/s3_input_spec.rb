require "spec_helper"
require "resource_spec_helper"
require "analyze_spec_helper"

s3_list_response = response_envelope({
  items: [{
    id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
    type: 'S3',
    name: 's3 input',
    description: 'desc',
    bucketName: 'bucket',
    cloudRegion: 'EU_CENTRAL_1'
  }]
})
s3_detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 's3 input',
  description: 'desc',
  bucketName: 'bucket',
  cloudRegion: 'EU_CENTRAL_1'
})
s3_detail_response = response_envelope(s3_detail)

test_resource_methods(Bitmovin::Encoding::Inputs::S3Input, "/v1/encoding/inputs/s3", {
  list: s3_list_response, 
  detail: s3_detail_response,
  item: s3_detail
})
test_analyze_method(Bitmovin::Encoding::Inputs::S3Input, "/v1/encoding/inputs/s3")
