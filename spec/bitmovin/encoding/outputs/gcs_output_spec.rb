require "spec_helper"

gcs_list_response = response_envelope({
  items: [{
    id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
    type: 'gcs',
    name: 'gcs output',
    description: 'desc',
    bucketName: 'bucket',
    cloudRegion: 'EU_CENTRAL_1'
  }]
})
gcs_detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 'gcs output',
  description: 'desc',
  bucketName: 'bucket',
  cloudRegion: 'EU_CENTRAL_1'
})
gcs_detail_response = response_envelope(gcs_detail)

test_resource_methods(Bitmovin::Encoding::Outputs::GcsOutput, "/v1/encoding/outputs/gcs", {
  list: gcs_list_response, 
  detail: gcs_detail_response,
  item: gcs_detail
})
