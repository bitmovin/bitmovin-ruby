module Bitmovin
  class Resource
    include Bitmovin::Helpers

    def self.resource_path(path)
      @@path = path
    end

    def self.list(limit = 100, offset = 0)
      response = Bitmovin.client.get @@path, limit: limit, offset: offset
      Bitmovin::Helpers.result(response)['items'].map do |item|
        self.new(item)
      end
    end

    def self.find(id)
      response = Bitmovin.client.get File.join(@@path, id)
      self.new(Bitmovin::Helpers.result(response))
    end

    def initialize(hash)
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    def delete
      Bitmovin.client.delete File.join(@@path, @id)
    end
  end
end
