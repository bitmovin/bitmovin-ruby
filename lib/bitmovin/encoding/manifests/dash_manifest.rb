module Bitmovin::Encoding::Manifests
  class DashManifest < Bitmovin::Resource
    init("/v1/encoding/manifests/dash")

    def initialize(hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      super(hash)
      @adaptationsets = DashAdaptationset.new(@id)
      @outputs = (hsh[:outputs] || []).map { |output| Bitmovin::Encoding::Encodings::StreamOutput.new(output) }
      @periods = nil
    end

    attr_accessor :outputs, :manifest_name
    def periods
      if @periods.nil?
        @periods = load_periods
      end
      @periods
    end

    def build_period(hash = {})
      period = Period.new(@id, hash) 
      period
    end

    #attr_reader :adaptationsets
    def adaptationsets
      raise "not implemented yet"
    end

    def persisted?
      !@id.nil?
    end

    def reload!
      @periods = nil
    end

    private
    def load_periods
      if !persisted?
        raise "Manifest is not persisted yet - can't load periods"
      end
      path = File.join("/v1/encoding/manifests/dash", @id, "periods")
      response = Bitmovin.client.get path
      result(response)["items"].map do |period|
        Period.new(@id, period)
      end
    end

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
