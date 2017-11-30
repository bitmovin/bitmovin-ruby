module Bitmovin::Webhooks
  class WebhookResource < Bitmovin::Resource
    attr_accessor :id, :url, :method, :insecure_ssl, :encryption, :signature
  end
end
