module Bitmovin
  class Client
    attr_accessor :api_key
    attr_accessor :base_url

    def initialize(config)
      @api_key = config[:api_key]
      @base_url = "https://api.bitmovin.com/v1"
      @conn = Faraday.new(url: @base_url, headers: {
          'X-Api-Key' => @api_key,
          'X-Api-Client-Version' => Bitmovin::VERSION,
          'X-Api-Client' => 'bitmovin-ruby'
        }) do |faraday|
        faraday.adapter :httpclient
      end
    end

    def get(*args, &block)
      @conn.get *args, &block
    end

    def delete(*args, &block)
      @conn.delete *args, &block
    end
  end
end
