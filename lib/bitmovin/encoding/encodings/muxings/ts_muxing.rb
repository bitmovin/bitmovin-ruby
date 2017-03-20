module Bitmovin::Encoding::Encodings::Muxings
  class TsMuxing < MuxingResource
    attr_accessor :segment_naming, :segment_length
  end
end
