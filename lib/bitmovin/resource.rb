module Bitmovin
  class Resource
    include Bitmovin::Helpers

    class << self
      def init(path)
        @resource_path = path
      end
      attr_reader :resource_path


      def list(limit = 100, offset = 0)
        response = Bitmovin.client.get @resource_path, limit: limit, offset: offset
        Bitmovin::Helpers.result(response)['items'].map do |item|
          new(item)
        end
      end

      def find(id)
        response = Bitmovin.client.get File.join(@resource_path, id)
        new(Bitmovin::Helpers.result(response))
      end
    end


    def initialize(hash)
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    def delete
      Bitmovin.client.delete File.join(self.class.resource_path, @id)
    end

    def inspect
      "#{self.class.name}(id: #{@id}, name: #{@name})"
    end
  end
end
