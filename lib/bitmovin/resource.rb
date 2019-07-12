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

    def init_instance(path)
      @instance_resource_path = path
    end

    attr_accessor :id, :name, :description, :created_at, :modified_at


    def initialize(hash = {})
      init_from_hash(hash)
    end

    def save!
      if @id
        raise BitmovinError.new(self), "Cannot save already persisted resource"
      end

      response = Bitmovin.client.post do |post|
        post.url resource_path
        post.body = collect_attributes
      end
      yield(response.body) if block_given?
      init_from_hash(result(response))
      self
    end

    def persisted?
      !@id.nil?
    end

    def delete!
      Bitmovin.client.delete File.join(resource_path, @id)
    end

    def inspect
      "#{self.class.name}(id: #{@id}, name: #{@name})"
    end

    private

    def resource_path
      @instance_resource_path || self.class.resource_path
    end

    def init_from_hash(hash = {})
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    def collect_attributes
      ignored_variables = []
      if (self.respond_to?(:ignore_fields))
        ignored_variables = self.ignore_fields
      end
      ignored_variables.push(:@instance_resource_path)
      attributes_value = instance_variables.inject({}) do |result, item|
        if ignored_variables.include?(item)
          result
        else
          name = item == :@max_ctu_size ? 'maxCTUSize' : item.to_s.gsub(/@/, '')
          result.merge(
            name => instance_variable_get(item)
          )
        end
      end
      camelize_hash(attributes_value)
    end
  end
end
