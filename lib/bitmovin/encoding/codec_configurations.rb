module Bitmovin::Encoding
  module CodecConfigurations
    def CodecConfigurations.list(limit = 100, offset = 0)
      response = Bitmovin.client.get '/v1/encoding/configurations', { limit: limit, offset: offset }
      Bitmovin::Helpers.result(response)['items'].map do |item|
        case item['type'].downcase
        when "h264"
          H264Configuration.new(item)
        end
      end
    end
  end
end
require 'bitmovin/encoding/codec_configurations/h264_configuration'
