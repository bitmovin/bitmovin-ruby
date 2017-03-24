require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "webmock/rspec"
require "pry"
require "bitmovin-ruby"
require "rspec"
require "rspec/collection_matchers"

RSpec.configure do |rspec|
  rspec.before(:all) do
    Bitmovin.init({ api_key: 'test' })
  end
end

def sample_list_body
  JSON.parse({
    data: {
      result: {
        items: [
          { 
            type: 'S3',
            name: 's3 input',
            description: 'desc',
            bucketName: 'bucket',
            cloudRegion: 'EU_CENTRAL_1'
          }
        ]
      }
    }
  }.to_json)
end

def response_envelope(children)
  return { 
    data: {
      result: children
    }
  }
end

def sample_list_body_http
  {
    body: sample_list_body.to_json
  }
end

def url_pattern(url)
  /https?:\/\/api\.bitmovin\.com\/v1\/#{url}\?.*/
end

def stub_list(method, url, response)
  stub_request(method, url_pattern(url))
    .to_return(response)
end

def assert_list_call(method, url, klass)
  it "should have method list()" do
    expect(subject).to respond_to(:list).with(0..2).arguments
  end
  describe "list()" do
    it "should call GET #{url}" do
      stub_list(method, url, sample_list_body_http)
      expect(subject.list(100, 0)).to have_requested(:get, url_pattern(url))
    end
  end
  it "should return a list" do
    stub_list(method, url, { body: sample_list_body.to_json })
    response = subject.list()
    expect(response).to be_a(Array)
  end
  it "should return a list including #{klass}" do
    stub_list(method, url, { body: sample_list_body.to_json })
    response = subject.list()
    expect(response).to include(be_a(klass))
  end
  it "should return list with correct size" do
    stub_list(method, url, { body: sample_list_body.to_json })
    response = subject.list()
    expect(response.size).to eq(1)
  end
end
