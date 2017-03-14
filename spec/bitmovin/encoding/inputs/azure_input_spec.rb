require "spec_helper"
require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 'azure input',
  description: 'desc',
  accountName: 'foo',
  accountKey: 'secret',
  container: 'test'
})
list_response = response_envelope({
  items: [detail]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::Inputs::AzureInput, "/v1/encoding/inputs/azure", {
  list: list_response, 
  detail: detail_response,
  item: detail
})
