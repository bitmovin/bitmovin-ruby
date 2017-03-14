module Bitmovin
  class InputResource < Resource
    def analyze!(options)
      response = Bitmovin.client.post(File.join(self.class.resource_path, @id, 'analysis')) do |req|
        req.body = camelize_hash(options)
      end
      result = (JSON.parse(response.body))['data']['result']
      Bitmovin::Encoding::Inputs::Analysis.new(@id, result['id'])
    end
  end
end
