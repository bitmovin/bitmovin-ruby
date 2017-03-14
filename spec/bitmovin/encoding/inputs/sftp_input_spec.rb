require "spec_helper"
require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: '7efd17bc-c94e-4c2f-93c0-1affde88fdc2',
  name: 'sftp input',
  description: 'desc',
  host: '127.0.0.1',
  port: '21',
  username: 'root',
  password: 'secret'
})
list_response = response_envelope({
  items: [detail]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::Inputs::SftpInput, "/v1/encoding/inputs/sftp", {
  list: list_response, 
  detail: detail_response,
  item: detail
})
