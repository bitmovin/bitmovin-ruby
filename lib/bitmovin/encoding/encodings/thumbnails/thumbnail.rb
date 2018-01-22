module Bitmovin::Encoding::Encodings
  class Thumbnail < Bitmovin::Resource

    def initialize(encoding_id, stream_id, hash = {})
      @errors = []
      self.class.init(File.join('/v1/encoding/encodings', encoding_id, 'streams', stream_id, 'thumbnails'))

      @encoding_id = encoding_id
      @stream_id = stream_id

      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @positions = hsh[:positions] || []
      @unit = hsh[:unit]
      @height = hsh[:height]
      @pattern = hsh[:pattern]
      @outputs = (hsh[:outputs] || []).map { |output| Bitmovin::Encoding::StreamOutput.new(output) }
    end

    attr_accessor :positions, :unit, :height, :pattern, :outputs

    def save!
      if valid?
        super
      end
    end

    def errors
      @errors
    end

    def valid?
      validate!
      unless @errors.empty?
        puts errors
        return false
      end
      true
    end

    def invalid?
      !valid?
    end

    def validate!
      @errors = []

      if @positions.nil? || @positions.empty?
        @errors << 'There has to be at least one position for a thumbnail'
      end

      if @height.nil? || @height <= 0
        @errors << 'The height has to be set and must be greater than 0'
      end

      if @pattern.nil? || @pattern.blank?
        @errors << 'The pattern has to be set and must not be blank'
      end

      unless ['SECONDS', 'PERCENTS', nil].include? @unit
        @errors << "The unit can only be 'SECONDS' or 'PERCENTS'"
      end

      @outputs.each do |output|
        @errors << output.errors unless output.valid?
      end

      @errors.flatten!
    end

  end
end