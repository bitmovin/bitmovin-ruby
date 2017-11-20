module Bitmovin::Encoding::Encodings::Muxings::Drms
  class TsMuxingDrmList
    def initialize(encoding_id, muxing_id, hash = {})
      @aes = TsMuxingAesEncryptionList.new(encoding_id, muxing_id)
    end

    def aes
      @aes
    end
  end
end
