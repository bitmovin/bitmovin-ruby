module Bitmovin::Encoding::Encodings::Muxings
  class WebmMuxing < MuxingResource
    attr_accessor :segment_naming, :segment_length, :init_segment_name
  end
end
