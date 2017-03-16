module Bitmovin::Encoding::Encodings
  class EncodingTask < Bitmovin::Resource
    init "/v1/encoding/encodings"

    def initialize(hash = {})
      super(hash)
      @stream_list = StreamList.new(@id)
    end

    attr_accessor :id, :name, :description
    attr_reader :created_at, :modified_at
    attr_accessor :encoder_version, :cloud_region, :infrastructure_id, :status, :created_at, :modified_at, :type

    def live?
      type == "LIVE"
    end

    def vod?
      type == "VOD"
    end

    def streams
      @stream_list
    end

    def ignore_fields
      [:@stream_list]
    end

    def self.list(limit = 100, offset = 0)
      response = Bitmovin.client.get("/v1/encoding/encodings", { limit: limit, offset: offset })
      Bitmovin::Helpers.result(response)['items'].map do |item|
        EncodingTask.new(item)
      end
    end
  end
end
