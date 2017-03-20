module Bitmovin::Encoding::Encodings
  class MuxingList
    include Bitmovin::Helpers

    attr_accessor :encoding_id
    def initialize(encoding_id)
      @encoding_id = encoding_id
    end

  end
end
