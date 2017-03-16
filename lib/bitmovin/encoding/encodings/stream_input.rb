module Bitmovin::Encoding::Encodings
  class StreamInput
    def initialize(encoding_id, stream_id, hash)
      @errors = []
      @encoding_id = encoding_id
      @stream_id = stream_id
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    attr_accessor :encoding_id, :stream_id
    attr_accessor :input_id, :input_path, :selection_mode, :position

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
      [:input_id, :input_path, :selection_mode, :position].each do |name|
        json_name = ActiveSupport::Inflector.camelize(name.to_s, false)
        value = instance_variable_get("@#{name}")
        if (!value.nil?)
          val[json_name] = instance_variable_get("@#{name}")
        end
      end
      val
    end
    def validate!
      @errors << "input_id cannot be blank" if @input_id.blank?
      @errors << "input_path cannot be blank" if @input_path.blank?
      @errors << "selection_mode cannot be blank" if @selection_mode.blank?
      @errors << "position cannot be blank if selection_mode is not AUTO" if @position.blank? && @selection_mode != "AUTO"
    end
  end
end
