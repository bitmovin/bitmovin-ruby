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

  def underscore_hash(hash)
    if !hash.instance_of? Hash
      return hash
    end

    ret = Hash.new
    hash.each do |key, value|
      if value.instance_of?(Hash)
        value = underscore_hash(value)
      end
      if (value.instance_of?(Array))
        value = value.map { |v| underscore_hash(v) }
      end
      new_key = ActiveSupport::Inflector.underscore(key)
      new_key = new_key.to_sym if key.instance_of? Symbol
      ret[new_key] = value
    end
    ret
  end

  def hash_to_struct(hash)
    if !hash.instance_of? Hash
      return hash
    end

    ret = Hash.new
    hash.each do |key, value|
      if value.instance_of?(Hash)
        value = hash_to_struct(value)
      end
      if value.instance_of?(Array)
        value = value.map { |v| hash_to_struct(v) }
      end
      ret[key] = value
    end
    OpenStruct.new(ret)
  end
end
