module Bitmovin::Webhooks
  class EncodingErrorWebhook < WebhookResource
    init 'notifications/webhooks/encoding/encodings/error'
    def initialize(encoding_id, hash = {})
      if encoding_id.kind_of?(String)
        @encoding_id = encoding_id
        self.class.init("notifications/webhooks/encoding/encodings/#{encoding_id}/error")
      else
        hash = encoding_id
      end
      init_from_hash(hash)
    end
  end
end
