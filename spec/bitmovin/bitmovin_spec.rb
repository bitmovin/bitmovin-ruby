require "spec_helper"

describe Bitmovin do
  it "has a version number" do
    expect(Bitmovin::VERSION).not_to be nil
  end

  it "has init method" do
    expect(Bitmovin).to respond_to(:init)
  end

  describe "init()" do
    it "should init the client" do
      Bitmovin.init('foo')
      expect(Bitmovin.client).not_to be_nil
    end
    it "should set correct API key on client" do
      expect(Bitmovin::Client).to receive(:new).with({ api_key: 'foo' })
      Bitmovin.init('foo')
    end
  end
end
