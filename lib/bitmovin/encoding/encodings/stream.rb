module Bitmovin::Encoding::Encodings
  class Stream < Bitmovin::Resource
    attr_accessor :encoding_id
    attr_accessor :id

    def initialize(encoding_id, hash)
      @encoding_id = encoding_id
      @resource_path = File.join("/v1/encoding/encodings/", encoding_id, "streams")
      super(hash)
    end
  end
end
