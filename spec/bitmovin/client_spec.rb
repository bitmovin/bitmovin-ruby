require "spec_helper"

describe Bitmovin::Client do
  describe "new" do
    subject { Bitmovin::Client.new({ api_key: 'foobar' }) }
    it "should set api key" do
      expect(subject.api_key).to eq('foobar')
    end

    it "should set correct base_url" do
      expect(subject.base_url).to eq('https://api.bitmovin.com/v1')
    end
  end

  describe "get" do
    subject { Bitmovin::Client.new({ api_key: 'test' }) }
    it "should make GET http call with API key as header" do
      stub_request(:get, 'https://api.bitmovin.com/v1/account/information')
        .with(headers: { 'X-Api-Key': 'test' })

      expect(subject.get('account/information')).to have_requested(:get, 'https://api.bitmovin.com/v1/account/information')
    end

    it "should set X-Api-Client-Version to Bitmovin::VERSION" do
      stub_request(:get, 'https://api.bitmovin.com/v1/account/information')
        .with(headers: { 'X-Api-Client-Version': Bitmovin::VERSION })

      expect(subject.get('account/information')).to have_requested(:get, 'https://api.bitmovin.com/v1/account/information')
    end

    it "should set X-Api-Client to bitmovin-ruby" do
      stub_request(:get, 'https://api.bitmovin.com/v1/account/information')
        .with(headers: { 'X-Api-Client': 'bitmovin-ruby' })

      expect(subject.get('account/information')).to have_requested(:get, 'https://api.bitmovin.com/v1/account/information')
    end
  end

end
