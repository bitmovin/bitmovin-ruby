module Bitmovin::Encoding::Encodings::Muxings::Drms
  class TsMuxingAesEncryptionList < Bitmovin::Encoding::Encodings::List
    init "muxings", Bitmovin::Encoding::Encodings::Muxings::Drms::TsMuxingAesEncryption

    attr_accessor :muxing_id
    def initialize(encoding_id, muxing_id, hash = {})
      @encoding_id = encoding_id
      @muxing_id = muxing_id
    end

    def build(hash = {})
      self.class.klass.new(@encoding_id, @muxing_id, hash)
    end
  end
end
