require "spec_helper"
require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 's3 input',
  description: 'desc'
})
detail_response = response_envelope(detail)
list_response = response_envelope({
  items: [
    detail.merge(type: 'rtmp')
  ]
})
test_resource_methods(Bitmovin::Encoding::Inputs::RtmpInput, "/v1/encoding/inputs/rtmp", {
  list: list_response, 
  detail: detail_response,
  item: detail
})
