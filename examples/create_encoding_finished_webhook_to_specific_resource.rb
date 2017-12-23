require '../lib/bitmovin-ruby'

Bitmovin.init("YOUR API KEY")

# Adding finished webhook to encoding
finished_webhook = Bitmovin::Webhooks::EncodingFinishedWebhook.new('ENCODING_ID', {
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

begin
finished_webhook.save!
rescue Exception => e
  puts e.inspect
end
puts "Added finished webkook with id #{finished_webhook.id}!"
