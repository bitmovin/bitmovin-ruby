module Bitmovin
  class Client
    attr_accessor :api_key
    attr_accessor :base_url

    def initialize(config)
      @api_key = config[:api_key]
      @base_url = "https://api.bitmovin.com/v1"
      headers = {
        'X-Api-Key' => @api_key,
        'X-Api-Client-Version' => Bitmovin::VERSION,
        'X-Api-Client' => 'bitmovin-ruby',
        'Content-Type' => 'application/json'
      }
      headers['X-Tenant-Org-Id'] = config[:organisation_id] if config[:organisation_id]
      @conn = Faraday.new(url: @base_url, headers: headers) do |faraday|

        faraday.request :json
        #faraday.response :logger
        faraday.adapter :httpclient
        faraday.response :raise_error
      end
    end

    def get(*args, &block)
      @conn.get *args, &block
    end

    def delete(*args, &block)
      @conn.delete *args, &block
    end

    def post(*args, &block)
      @conn.post *args, &block
    end
  end
end
