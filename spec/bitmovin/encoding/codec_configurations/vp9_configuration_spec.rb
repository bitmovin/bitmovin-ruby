require 'spec_helper'

require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: SecureRandom.uuid,
  name: "iPad",
  description: "iPad configuration",
  bitrate: 10000000,
  rate: 23.97,
  tileColumns: 0,
  tileRows: 0,
  frameParallel: false,
  maxIntraRate: 0,
  qpMin: 0,
  qpMax: 63,
  rateUndershootPct: 25,
  rateOvershootPct: 25,
  cpuUsed: 1,
  quality: "GOOD",
  lossless: false,
  aqMode: "NONE",
  arnrMaxFrames: 0,
  arnrStrength: 3,
  arnrType: "CENTERED"
})
list = response_envelope({
  items: [
    detail
  ]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::CodecConfigurations::Vp9Configuration, "/v1/encoding/configurations/video/vp9", {
  list: list, 
  detail: detail_response,
  item: detail
})
