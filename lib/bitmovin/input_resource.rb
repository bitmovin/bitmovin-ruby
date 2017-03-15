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

    def analyses
      Encoding::Inputs::Analysis.new(@id)
    end
  end
end
