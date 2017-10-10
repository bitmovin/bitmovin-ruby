module Bitmovin::Encoding::Encodings::Muxings::Drms
  class DrmMuxingResource < Bitmovin::Resource
    attr_accessor :name, :description, :created_at, :modified_at
    attr_accessor :encoding_id, :muxing_id
    attr_accessor :id
    attr_accessor :outputs

    def initialize(encoding_id, muxing_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @encoding_id = encoding_id
      @muxing_id = muxing_id
      muxing_type = self.class.name.demodulize.gsub(/(.*)Muxing.*/, '\1').downcase
      encryption_type = self.class.name.demodulize.gsub(/.*Muxing(.*)Encryption/, '\1').downcase
      self.class.init(File.join("/v1/encoding/encodings/", encoding_id, "muxings", muxing_type, muxing_id, "drm", encryption_type))
      super(hsh)
      @outputs = (hsh[:outputs] || []).map do |output|
        Bitmovin::Encoding::StreamOutput.new(output)
      end
    end

    def build_output(opts = {})
      output = Bitmovin::Encoding::StreamOutput.new(opts)
      @outputs << output
      output
    end

    private

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
        if name == :@outputs
          val["outputs"] = @outputs.map { |o| o.send(:collect_attributes) }
          next
        end

        if name == :@streams
          val["streams"] = @streams.map { |s| { "streamId" => s } }
          next
        end
        json_name = ActiveSupport::Inflector.camelize(name.to_s.gsub(/@/, ''), false)
        val[json_name] = instance_variable_get(name)
      end
      val
    end
  end
end
