module Bitmovin::Encoding::Encodings::Muxings::Drms
  class TsMuxingAesEncryption < Bitmovin::Encoding::Encodings::Muxings::Drms::DrmMuxingResource
    attr_accessor :method, :key_file_uri, :key, :iv
  end
end
