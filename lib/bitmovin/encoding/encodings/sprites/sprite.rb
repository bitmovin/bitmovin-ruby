module Bitmovin::Encoding::Encodings
  class Sprite < Bitmovin::Resource

    def initialize(encoding_id, stream_id, hash = {})
      @errors = []
      self.class.init(File.join('/v1/encoding/encodings', encoding_id, 'streams', stream_id, 'sprites'))

      @encoding_id = encoding_id
      @stream_id = stream_id

      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @height = hsh[:height]
      @width = hsh[:width]
      @sprite_name = hsh[:sprite_name]
      @vtt_name = hsh[:vtt_name]
      @distance = hsh[:distance]
      @outputs = (hsh[:outputs] || []).map {|output| Bitmovin::Encoding::StreamOutput.new(output)}
    end

    attr_accessor :height, :width, :sprite_name, :vtt_name, :distance, :outputs

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

      if @height == nil || @height < 0
        @errors << 'The height has to be set and must be greater than 0'
      end

      if @width == nil || @width < 0
        @errors << 'The width has to be set and must be greater than 0'
      end

      if @sprite_name == nil || @sprite_name.blank?
        @errors << 'The spriteName has to be set and must not be blank'
      end

      if @vtt_name == nil || @vtt_name.blank?
        @errors << 'The vttName has to be set and must not be blank'
      end

      if @distance < 0
        @errors << 'The distance is not allowed to be less than 0'
      end

      @outputs.each do |output|
        @errors << output.errors unless output.valid?
      end

      @errors.flatten!
    end

  end
end