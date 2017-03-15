require 'spec_helper'

require "resource_spec_helper"

detail = ActiveSupport::HashWithIndifferentAccess.new({
  type: 'h264',
  id: SecureRandom.hex,
  name: 'test',
  description: 'desc',
  width: "100",
  height: "200",
  bitrate: "100000",
  rate: "23.97",
  profile: 'BASELINE',
  bframes: "3",
  refFrames: "5",
  qpMin: "0",
  qpMax: "69",
  mvPredictionMode: 'AUTO',
  mvSearchRangeMax: "16",
  cabac: "true",
  maxBitrate: "0",
  minBitrate: "0",
  bufsize: "0",
  minGop: "0",
  maxGop: "0",
  level: "1b",
  bAdaptiveStrategy: "FAST",
  motionEstimationMethod: "HEX",
  rcLookAhead: "50",
  subMe: "FULLPEL",
  trellis: "DISABLED",
  partitions: ['P8X8', "P4X4"],
  slices: "1",
  interlaceMode: "NONE"
})
list = response_envelope({
  items: [
    detail
  ]
})
detail_response = response_envelope(detail)

test_resource_methods(Bitmovin::Encoding::CodecConfigurations::H264Configuration, "/v1/encoding/configurations/video/h264", {
  list: list, 
  detail: detail_response,
  item: detail
})
