class BitmovinError < StandardError
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end
end
