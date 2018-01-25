module Bitmovin::Encoding::Encodings
  class List
    include Bitmovin::Helpers

    class << self
      def init(path, klass)
        @resource_path = path
        @klass = klass
      end
      attr_reader :resource_path
      attr_reader :klass
      attr_reader :items
    end

    attr_accessor :encoding_id
    def initialize(encoding_id)
      @encoding_id = encoding_id
      @items = []
    end

    def list(limit = 100, offset = 0)
      path = File.join("/v1/encoding/encodings/", @encoding_id, self.class.resource_path)
      response = Bitmovin.client.get(path, { limit: limit, offset: offset })
      @items = result(response)['items'].map { |item| self.class.klass.new(@encoding_id, item) }
    end

    def add(stream)
      raise "Not implemented yet. Please use #build and Stream#save! for the time being"
    end

    def build(hash = {})
      stream = self.class.klass.new(@encoding_id, hash)
      @items << stream
      stream
    end

    def find(id)
      path = File.join("/v1/encoding/encodings/", @encoding_id, self.class.resource_path, id)
      response = Bitmovin.client.get(path)
      self.class.klass.new(@encoding_id, result(response))
    end
  end
end
