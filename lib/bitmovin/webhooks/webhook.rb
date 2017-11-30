module Bitmovin::Webhooks
  class Webhook < Bitmovin::Resource
    attr_accessor :id, :url, :method, :insecure_ssl, :encryption, :signature

    def initialize(encoding_id, event_type, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      self.class.init("/v1/notifications/webhooks/encoding/encodings/#{encoding_id}/#{event_type.downcase}")
      super(hsh)
      @url = hsh[:url]
      @encryption = hsh[:encryption]
      @signature = hsh[:signature]
      @insecure_ssl = hsh[:insecure_ssl]
      @method = hsh[:method]
    end
  end
end
