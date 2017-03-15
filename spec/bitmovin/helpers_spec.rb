require "spec_helper"

class SimpleTest
  include Bitmovin::Helpers
end

describe Bitmovin::Helpers do
  subject { SimpleTest.new }
  describe "underscore_hash" do
    it "should underscore all keys with strings" do
      given = { "testObject" => "foo" }
      expected = { "test_object" => "foo" }

      expect(subject.underscore_hash(given)).to eq(expected)
    end
    it "should underscore symbol keys" do
      given = { simpleTestSymbol: "foo" }
      expected = { simple_test_symbol: "foo" }

      expect(subject.underscore_hash(given)).to eq(expected)
    end

    it "should not change symbols to strings" do
      given = { symbol: "foo" }

      expect(subject.underscore_hash(given)).to eq(given)
    end

    it "should underscore embedded hashes too" do
      given = {
        parent: {
          simpleTest: "foo"
        }
      }

      expected = {
        parent: {
          simple_test: "foo"
        }
      }

      expect(subject.underscore_hash(given)).to eq(expected)
    end
  end
end
