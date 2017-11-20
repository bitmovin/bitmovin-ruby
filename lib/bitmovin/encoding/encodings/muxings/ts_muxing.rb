module Bitmovin::Encoding::Encodings::Muxings
  class TsMuxing < MuxingResource
    attr_accessor :id
    attr_accessor :encoding_id
    attr_accessor :segment_naming, :segment_length
    attr_accessor :drms

    def initialize(encoding_id, hash = {})
      super(encoding_id, hash)
      @encoding_id = encoding_id
    end

    def drms
      if !persisted?
        raise BitmovinError.new(self), "Cannot access drms of not persisted muxing"
      end
      Drms::TsMuxingDrmList.new(@encoding_id, @id)
    end
  end
end
