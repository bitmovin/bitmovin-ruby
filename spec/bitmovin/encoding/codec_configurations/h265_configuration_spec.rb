require 'spec_helper'

require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  id: SecureRandom.uuid,
  name: "iPad",
  description: "iPad configuration",
  bitrate: 10000000,
  rate: 23.97,
  profile: "main",
  bframes: 3,
  refFrames: 5,
  qp: 0,
  maxBitrate: 0,
  minBitrate: 0,
  bufsize: 0,
  minGop: 0,
  maxGop: 250,
  level: "0",
  rcLookahead: 20,
  bAdapt: "FULL",
  maxCTUSize: "64",
  tuIntraDepth: "1",
  tuInterDepth: "1",
  motionSearch: "HEX",
  subMe: 2,
  motionSearchRange: 57,
  weightPredictionOnPSlice: true,
  weightPredictionOnBSlice: false,
  sao: false
})
list = response_envelope({
  items: [
    detail
  ]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::CodecConfigurations::H265Configuration, "/v1/encoding/configurations/video/h265", {
  list: list, 
  detail: detail_response,
  item: detail
})
