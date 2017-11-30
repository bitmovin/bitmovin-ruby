module Bitmovin::Webhooks
  class WebhookEncryption
    def initialize(hash = {})
      @errors = []
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    attr_accessor :type, :key

    def valid?
      validate!
      @errors.empty?
    end

    def invalid?
      !valid?
    end

    def errors
      @errors
    end

    def to_json(args)
      collect_attributes.to_json(args)
    end

    private

    def collect_attributes
      val = Hash.new
      [:type, :key].each do |name|
        json_name = ActiveSupport::Inflector.camelize(name.to_s, false)
        val[json_name] = instance_variable_get("@#{name}")
      end
      val
    end

    def validate!
      @errors << "type cannot be blank" if @type.blank?
      @errors << "key cannot be blank" if @key.blank?
    end
  end
end