module Bitmovin::Encoding::Manifests
  class DashManifest < Bitmovin::Resource
    include Bitmovin::ChildCollection
    init("/v1/encoding/manifests/dash")

    def initialize(hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      super(hash)
      @outputs = (hsh[:outputs] || []).map { |output| Bitmovin::Encoding::StreamOutput.new(output) }
      @periods = nil
    end

    child_collection(:periods, "/v1/encoding/manifests/dash/%s/periods", [:id], Period)

    attr_accessor :outputs, :manifest_name

    def persisted?
      !@id.nil?
    end

    def reload!
      @periods = nil
    end

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
