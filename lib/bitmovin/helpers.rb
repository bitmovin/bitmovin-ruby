module Bitmovin::Helpers
  def result(response)
    Bitmovin::Helpers.result(response)
  end
  def self.result(response)
    (JSON.parse(response.body))['data']['result']
  end
end
