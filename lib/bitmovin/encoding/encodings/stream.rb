module Bitmovin::Encoding::Encodings
  class Stream < Bitmovin::Resource
    attr_accessor :encoding_id
    attr_accessor :id
    attr_accessor :conditions

    def initialize(encoding_id, hash = {})
      set_defaults
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @encoding_id = encoding_id
      self.class.init(File.join("/v1/encoding/encodings/", encoding_id, "streams"))
      super(hash)
      @outputs = (hsh[:outputs] || []).map { |output| Bitmovin::Encoding::StreamOutput.new(output) }
      @input_streams = (hsh[:input_streams] || []).map { |input| StreamInput.new(@encoding_id, @id, input) }

      @errors = []
      @conditions = nil
    end

    attr_accessor :name, :description, :created_at, :modified_at, :create_quality_meta_data

    def input_streams
      @input_streams
    end

    def build_input_stream(opts = {})
      input = StreamInput.new(@encoding_id, @id, opts)
      @input_streams << input
      input
    end

    def outputs
      @outputs
    end

    def build_output(opts = {})
      output = Bitmovin::Encoding::StreamOutput.new(opts)
      @outputs << output
      output
    end

    def codec_configuration=(configuration)
      if configuration.instance_of?(String)
        @codec_config_id = configuration
      else
        @codec_config_id = configuration.id
      end
    end
    def codec_configuration
      @codec_config_id
    end

    def save!
      if valid?
        super
      end
    end

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

    def input_details
      path = File.join("/v1/encoding/encodings/", @encoding_id, "streams", @id, "input")
      response = Bitmovin.client.get(path)
      hash_to_struct(result(response))
    end

    def input_analysis
      path = File.join("/v1/encoding/encodings/", @encoding_id, "streams", @id, "inputs")
      response = Bitmovin.client.get(path)
      hash_to_struct(result(response))
    end

    private
    def collect_attributes
      val = Hash.new
      [:name, :description, :create_quality_meta_data,
      :input_streams, :outputs, :codec_config_id, :conditions].each do |name|
        json_name = ActiveSupport::Inflector.camelize(name.to_s, false)
        val[json_name] = instance_variable_get("@#{name}")
      end
      if @conditions.nil?
        val.delete("conditions")
      end
      val
    end
    def validate!
      @errors = []
      if @input_streams.empty?
        @errors << "Stream needs at least one input_stream"
      end
      @input_streams.each do |stream|
        @errors << stream.errors if !stream.valid?
      end

      @outputs.each do |output|
        @errors << output.errors if !output.valid?
      end

      @errors << "codec_configuration must be set" if @codec_config_id.blank?

      @errors.flatten!
    end

    def set_defaults
      @create_quality_meta_data = false
    end
  end
end
