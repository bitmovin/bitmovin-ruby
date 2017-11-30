require 'bitmovin-ruby'

# Adding finished webhook to encoding
finished_webhook = Bitmovin::Webhooks::EncodingFinishedWebhook.new(
    {
        method: 'POST',
        insecure_ssl: 'false',
        url: 'http://httpbin.org/post',
        encryption: Bitmovin::Webhooks::WebhookEncryption.new({
                                                                  key: 'mySecretKey',
                                                                  type: 'AES'
                                                              }),
        signature: Bitmovin::Webhooks::WebhookSignature.new({
                                                                key: 'mySecretKey',
                                                                type: 'HMAC'
                                                            })
    }
)

finished_webhook.save!
puts "Added finished webkook with id #{finished_webhook.id}!"