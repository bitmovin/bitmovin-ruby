require "spec_helper"
require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 'ftp input',
  description: 'desc',
  host: '127.0.0.1:21',
  username: 'root',
  password: 'secret',
  passive: "true"
})
list_response = response_envelope({
  items: [detail]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::Inputs::FtpInput, "/v1/encoding/inputs/ftp", {
  list: list_response, 
  detail: detail_response,
  item: detail
})
