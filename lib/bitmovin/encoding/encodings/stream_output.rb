module Bitmovin::Encoding::Encodings
  class StreamOutput
    def initialize(encoding_id, stream_id, hash)
      @encoding_id = encoding_id
      @stream_id = stream_id
      hash.each do |name, value|
        instance_variable_set("@#{ActiveSupport::Inflector.underscore(name)}", value)
      end
    end

    attr_accessor :encoding_id, :stream_id
    attr_accessor :output_id, :output_path, :acl
  end
end
