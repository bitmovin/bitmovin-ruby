module Bitmovin
  class InputResource < Resource
    def analyze!(options)
      path = File.join("/v1/encoding/inputs/", @id, "analysis")
      response = Bitmovin.client.post(path) do |req|
        req.body = camelize_hash(options)
      end
      result = (JSON.parse(response.body))['data']['result']
      Bitmovin::Encoding::Inputs::AnalysisTask.new(self, result['id'])
    end

    def analyses(limit = 100, offset = 0)
      path = File.join("/v1/encoding/inputs/", @id, "analysis")
      response = Bitmovin.client.get(path)
      JSON.parse(response.body)['data']['result'].map do |result|
        hash_to_struct(underscore_hash(result))
      end
    end
  end
end
