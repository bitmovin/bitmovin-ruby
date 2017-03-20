module Bitmovin::Encoding
  module Encodings
    # Alias for EncodingTask#list
    def self.list(*args)
      EncodingTask.list(*args)
    end
  end
end
require 'bitmovin/encoding/encodings/encoding_task'
require 'bitmovin/encoding/encodings/stream_list'
require 'bitmovin/encoding/encodings/muxing_list'
require 'bitmovin/encoding/encodings/stream'
require 'bitmovin/encoding/encodings/stream_output'
require 'bitmovin/encoding/encodings/stream_input'
