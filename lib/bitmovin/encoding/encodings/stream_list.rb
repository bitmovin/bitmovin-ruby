module Bitmovin::Encoding::Encodings
  class StreamList
    include Bitmovin::Helpers

    attr_accessor :encoding_id
    def initialize(encoding_id)
      @encoding_id = encoding_id
    end

    def list(limit = 100, offset = 0)
      path = File.join("/v1/encoding/encodings/", @encoding_id, "streams")
      response = Bitmovin.client.get(path, { limit: limit, offset: offset })
      result(response)['items'].map { |item| Stream.new(@encoding_id, item) }
    end

    def add(stream)
      # TODO
    end

    def build
      # TODO
    end

    def find(id)
      # TODO
    end
  end
end
