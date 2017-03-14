module Bitmovin::Encoding::Inputs
  class FtpInput < Bitmovin::Resource
    init 'encoding/inputs/ftp'
    attr_accessor :id, :created_at, :modified_at, :name, :description
    attr_accessor :host, :username, :password, :passive, :port
  end
end
