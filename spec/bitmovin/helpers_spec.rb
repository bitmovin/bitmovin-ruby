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

    it "should handle embedded arrays" do
      given = { items: [ 1, 2, 3 ] }
      expect(subject.underscore_hash(given)).to eq(given)
    end

    it "should underscore hashes in embedded arrays" do
      given = { items: [
        { testItem: 'foo' }, { testItem: 'bar' }
      ]}
      expect(subject.underscore_hash(given)).to eq({
        items: [
          { test_item: 'foo' },
          { test_item: 'bar' }
        ]
      })
    end
  end
  describe "hash_to_struct" do
    it "should transform hash to OpenStruct" do
      given = { id: 1 }
      expect(subject.hash_to_struct(given)).to respond_to(:id)
      expect(subject.hash_to_struct(given).id).to eq(1)
    end

    it "should transform embedded hashes to OpenStruct too" do
      given = { item: { id: 1 } }
      expect(subject.hash_to_struct(given).item).to respond_to(:id)
      expect(subject.hash_to_struct(given).item.id).to eq(1)
    end

    it "should handle embedded arrays" do
      given = { item: [1, 2, 3] }
      expect(subject.hash_to_struct(given).item).to eq([1, 2, 3])
    end

    it "should convert hashes in embedded arrays to OpenStruct" do
      given = { item: [{ foo: 'bar' }] }

      expect(subject.hash_to_struct(given).item.first).to respond_to(:foo)
      expect(subject.hash_to_struct(given).item.first.foo).to eq('bar')
    end
  end
end
