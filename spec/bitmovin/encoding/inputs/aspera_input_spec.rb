require "spec_helper"
require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 'http input',
  description: 'desc',
  host: '127.0.0.1',
  username: 'root',
  password: 'secret',
  minBandwith: '100m',
  maxBandwith: '100k'
})
list_response = response_envelope({
  items: [detail]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::Inputs::HttpInput, "/v1/encoding/inputs/http", {
  list: list_response, 
  detail: detail_response,
  item: detail
})
