module Bitmovin::Encoding::Inputs
  class Analysis
    include Bitmovin::Helpers
    def initialize(input_id)
      @id = input_id
    end

    def list(limit = 100, offset = 0)
      path = File.join("/v1/encoding/inputs/", @id, "analysis")
      response = Bitmovin.client.get(path, limit: limit, offset: offset)
      result(response).map do |result|
        subtask_hash_to_object(result)
      end
    end

    def find(id)
      path = File.join("/v1/encoding/inputs", @id, "analysis", id)
      response = Bitmovin.client.get(path)
      subtask_hash_to_object(result(response))
    end

    private
    def subtask_hash_to_object(hash)
      hash_to_struct(underscore_hash(hash))
    end
  end
end
