module Bitmovin::Encoding::Manifests
  class DashManifest < Bitmovin::Resource
    init("/v1/encoding/manifests/dash")

    def initialize(hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      super(hash)
      @adaptationsets = DashAdaptationset.new(@id)
      @outputs = (hsh[:outputs] || []).map { |output| Bitmovin::Encoding::Encodings::StreamOutput.new(@encoding_id, @id, output) }
    end

    attr_accessor :outputs, :manifest_name
    attr_reader :adaptationsets

    private
    def collect_attributes
      val = Hash.new
      [:name, :description, :manifest_name].each do |name|
        json_name = ActiveSupport::Inflector.camelize(name.to_s, false)
        val[json_name] = instance_variable_get("@#{name}")
      end
      val["outputs"] = @outputs.map { |o| o.send(:collect_attributes) }
      val
    end
  end
end
