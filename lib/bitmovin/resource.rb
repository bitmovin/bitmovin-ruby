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

    attr_accessor :id, :name, :description, :created_at, :modified_at


    def initialize(hash = {})
      init_from_hash(hash)
    end

    def save!
      if @id
        raise BitmovinError.new(self), "Cannot save already persisted resource"
      end

      response = Bitmovin.client.post do |post|
        post.url self.class.resource_path
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
      Bitmovin.client.delete File.join(self.class.resource_path, @id)
    end

    def inspect
      "#{self.class.name}(id: #{@id}, name: #{@name})"
    end

    private

    def init_from_hash(hash = {})
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    def collect_attributes
      val = Hash.new
      ignored_variables = []
      if (self.respond_to?(:ignore_fields))
        ignored_variables = self.ignore_fields
      end
      instance_variables.each do |name|
        if ignored_variables.include?(name)
          next
        end
        if name == :@max_ctu_size
          val['maxCTUSize'] = instance_variable_get(name)
        else
          json_name = ActiveSupport::Inflector.camelize(name.to_s.gsub(/@/, ''), false)
          val[json_name] = instance_variable_get(name)
        end
      end
      val
    end
  end
end
