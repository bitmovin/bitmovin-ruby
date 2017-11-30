module Bitmovin::Encoding
  module Outputs
    def self.list(limit = 100, offset = 0)
      response = Bitmovin.client.get '/v1/encoding/outputs', { limit: limit, offset: offset }
      result = (JSON.parse(response.body))['data']['result']
      list = result['items'].map do |item|
        case item['type'].downcase
        when "s3"
          S3Output.new(item)
        when "gcs"
          GcsOutput.new(item)
        end
      end
      list
    end
  end
end
require 'bitmovin/encoding/outputs/s3_output'
require 'bitmovin/encoding/outputs/gcs_output'
