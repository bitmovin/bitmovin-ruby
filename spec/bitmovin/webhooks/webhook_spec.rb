require "spec_helper"
require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
                                                          id: "5037625f-ed08-42cf-a1df-26328e02fd21",
                                                          url: "https://yourendpoint.yourcorp.com/webhooks/encoding/finished",
                                                          method: "POST",
                                                          insecureSsl: false,
                                                          signature: {
                                                              type: "HMAC",
                                                              key: "secretKey"
                                                          },
                                                          encryption: {
                                                              type: "AES",
                                                              key: "secretKey"
                                                          }
                                                      })
list_response = response_envelope({
                                      items: [detail]
                                  })
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Webhooks::EncodingFinishedWebhook, "/notifications/webhooks/encoding/encodings/finished", {
    list: list_response,
    detail: detail_response,
    item: detail
})
