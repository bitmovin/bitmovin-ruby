require 'spec_helper'

require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: SecureRandom.uuid,
  description: "test aac",
  bitrate: 128000,
  rate: 48000,
  channelLayout: "NONE",
  volumeAdjust: 100,
  normalize: false
})
list = response_envelope({
  items: [
    detail
  ]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::CodecConfigurations::AacConfiguration, "/v1/encoding/configurations/audio/aac", {
  list: list, 
  detail: detail_response,
  item: detail
})
