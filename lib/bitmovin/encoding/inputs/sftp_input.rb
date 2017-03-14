module Bitmovin::Encoding::Inputs
  class SftpInput < Bitmovin::Resource
    init 'encoding/inputs/sftp'
    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :host, :username, :password, :port
  end
end
