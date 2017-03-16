module Bitmovin::Encoding::Encodings
  class StreamOutput
    def initialize(encoding_id, stream_id, hash)
      @errors = []
      @encoding_id = encoding_id
      @stream_id = stream_id
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    attr_accessor :encoding_id, :stream_id
    attr_accessor :output_id, :output_path, :acl

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

    private
    def validate!
      @errors << "output_id cannot be blank" if @output_id.blank?
      @errors << "output_path cannot be blank" if @output_path.blank?
    end
  end
end
