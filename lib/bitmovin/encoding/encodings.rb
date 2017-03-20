module Bitmovin::Encoding
  module Encodings
    # Alias for EncodingTask#list
    def self.list(*args)
      EncodingTask.list(*args)
    end
  end
end
require 'bitmovin/encoding/encodings/stream'
require 'bitmovin/encoding/encodings/stream_output'
require 'bitmovin/encoding/encodings/stream_input'
require 'bitmovin/encoding/encodings/encoding_task'
require 'bitmovin/encoding/encodings/list'
require 'bitmovin/encoding/encodings/stream_list'
require 'bitmovin/encoding/encodings/stream_list'
require 'bitmovin/encoding/encodings/muxing_list'
require 'bitmovin/encoding/encodings/muxings/muxing_resource'
require 'bitmovin/encoding/encodings/muxings/fmp4_muxing'
require 'bitmovin/encoding/encodings/muxings/ts_muxing'
require 'bitmovin/encoding/encodings/muxings/fmp4_muxing_list'
require 'bitmovin/encoding/encodings/muxings/ts_muxing_list'
require 'bitmovin/encoding/encodings/muxings/mp4_muxing'
require 'bitmovin/encoding/encodings/muxings/mp4_muxing_list'
require 'bitmovin/encoding/encodings/muxings/webm_muxing'
require 'bitmovin/encoding/encodings/muxings/webm_muxing_list'
