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
    end

    attr_accessor :encoding_id
    def initialize(encoding_id)
      @encoding_id = encoding_id
    end

    def list(limit = 100, offset = 0)
      path = File.join("/v1/encoding/encodings/", @encoding_id, self.class.resource_path)
      response = Bitmovin.client.get(path, { limit: limit, offset: offset })
      result(response)['items'].map { |item| self.class.klass.new(@encoding_id, item) }
    end

    def add(stream)
      raise "Not implemented yet. Please use #build and Stream#save! for the time being"
    end

    def build(hash = {})
      self.class.klass.new(@encoding_id, hash)
    end

    def find(id)
      path = File.join("/v1/encoding/encodings/", @encoding_id, self.class.resource_path, id)
      response = Bitmovin.client.get(path)
      self.class.klass.new(@encoding_id, result(response))
    end
  end
end
