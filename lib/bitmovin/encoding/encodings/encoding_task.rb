module Bitmovin::Encoding::Encodings
  class EncodingTask < Bitmovin::Resource
    init "/v1/encoding/encodings"

    attr_accessor :name, :description
    attr_reader :created_at, :modified_at
    attr_accessor :encoder_version, :cloud_region, :infrastructure_id, :id, :status, :created_at, :modified_at, :type

    def live?
      type == "LIVE"
    end

    def vod?
      type == "VOD"
    end


    def self.list(limit = 100, offset = 0)
      response = Bitmovin.client.get("/v1/encoding/encodings", { limit: limit, offset: offset })
      Bitmovin::Helpers.result(response)['items'].map do |item|
        EncodingTask.new(item)
      end
    end
  end
end
