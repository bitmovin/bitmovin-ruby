module Bitmovin::Encoding
  module Inputs
    def Inputs.list(limit = 100, offset = 0)
      conn = Faraday.new(url: 'https://api.bitmovin.com')
      response = conn.get '/v1/encoding/inputs', { limit: limit, offset: offset }
      result = (JSON.parse(response.body))['data']['result']
      list = result['items'].map do |item|
        case item['type'].downcase
        when "s3"
          S3Input.new(item)
        end
      end
      list
    end
  end
end
require 'bitmovin/encoding/inputs/s3_input'
