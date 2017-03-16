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
    end

    private 
    def validate!
      @errors << "input_id cannot be blank" if @input_id.blank?
      @errors << "input_path cannot be blank" if @input_path.blank?
      @errors << "selection_mode cannot be blank" if @selection_mode.blank?
      @errors << "position cannot be blank if selection_mode is not AUTO" if @position.blank? && @selection_mode != "AUTO"
    end
  end
end
