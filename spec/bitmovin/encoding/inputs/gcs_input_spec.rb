require "spec_helper"
require "resource_spec_helper"

gcs_detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 'gcs input',
  description: 'desc',
  bucketName: 'bucket',
  cloudRegion: 'EU_CENTRAL_1'
})
gcs_list_response = response_envelope({
  items: [gcs_detail]
})
gcs_detail_response = response_envelope(gcs_detail)

test_resource_methods(Bitmovin::Encoding::Inputs::GcsInput, "/v1/encoding/inputs/gcs", {
  list: gcs_list_response, 
  detail: gcs_detail_response,
  item: gcs_detail
})
