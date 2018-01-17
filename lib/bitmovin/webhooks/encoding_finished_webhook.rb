module Bitmovin::Webhooks
  class EncodingFinishedWebhook < WebhookResource
    init 'notifications/webhooks/encoding/encodings/finished'
    def initialize(encoding_id = {}, hash = {})
      if encoding_id.kind_of?(String)
        @encoding_id = encoding_id
        self.class.init("notifications/webhooks/encoding/encodings/#{encoding_id}/finished")
      else
        hash = encoding_id
      end
      init_from_hash(hash)
    end
  end
end
