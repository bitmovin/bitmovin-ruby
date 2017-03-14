require "spec_helper"
require "resource_spec_helper"

s3_detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 's3 input',
  description: 'desc',
  bucketName: 'bucket',
  cloudRegion: 'EU_CENTRAL_1',
  host: '127.0.0.1',
  port: "3000"
})
s3_list_response = response_envelope({
  items: [s3_detail]
})
s3_detail_response = response_envelope(s3_detail)

test_resource_methods(Bitmovin::Encoding::Inputs::GenericS3Input, "/v1/encoding/inputs/generic-s3", {
  list: s3_list_response, 
  detail: s3_detail_response,
  item: s3_detail
})
