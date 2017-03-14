module Bitmovin::Helpers
  def result(response)
    Bitmovin::Helpers.result(response)
  end

  def self.result(response)
    (JSON.parse(response.body))['data']['result']
  end

  def camelize_hash(hash)
    ret = Hash.new
    hash.each do |key, value|
      ret[ActiveSupport::Inflector.camelize(key, false)] = value
    end
    ret
  end
end
