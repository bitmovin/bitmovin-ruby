module Bitmovin::Encoding::Encodings::Drms
    class Fmp4DrmResource < Bitmovin::Resource
      attr_accessor :name, :description, :created_at, :modified_at
      attr_accessor :encoding_id
      attr_accessor :fmp4_id
      attr_accessor :id
  
      def initialize(encoding_id, fmp4_id, hash = {})
        hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
        @encoding_id = encoding_id
        @fmp4_id = fmp4_id
        drm_type = self.class.name.demodulize.gsub(/(.*)Drm/, '\1').downcase
        self.class.init(File.join("/v1/encoding/encodings/", encoding_id, "muxings", "fmp4", fmp4_id, "drm", drm_type))
        super(hsh)
        @outputs = (hsh[:outputs] || []).map do |output|
          Bitmovin::Encoding::StreamOutput.new(output)
        end
      end
  
      attr_accessor :outputs
  
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
  
          json_name = ActiveSupport::Inflector.camelize(name.to_s.gsub(/@/, ''), false)
          val[json_name] = instance_variable_get(name)
        end
        val
      end
    end
  end