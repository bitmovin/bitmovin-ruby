module Bitmovin::Encoding::Encodings::InputStreams
  class Ingest < Bitmovin::Resource
    attr_accessor :encoding_id, :input_id, :input_path, :selection_mode, :position,
      :name, :description, :created_at, :modified_at, :errors

    def initialize(encoding_id, hash = {})
      hsh = ActiveSupport::HashWithIndifferentAccess.new(underscore_hash(hash))
      @encoding_id = encoding_id

      init_instance(File.join("/v1/encoding/encodings/", encoding_id, "input-streams/ingest"))
      super(hash)

      @input_id = hash[:input_id]
      @input_path = hash[:input_path]
      @selection_mode = hash[:selection_mode]
      @position = hash[:position]

      @errors = []
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

    def validate!
      @errors << "input_id cannot be blank" if @input_id.blank?
      @errors << "input_path cannot be blank" if @input_path.blank?
      @errors << "selection_mode cannot be blank" if @selection_mode.blank?
      @errors << "position cannot be blank if selection_mode is not AUTO" if @position.blank? && @selection_mode != "AUTO"
    end
  end
end
