module Bitmovin
  class Client
    attr_accessor :api_key
    def initialize(config)
      @api_key = config[:api_key]
    end
  end
end
