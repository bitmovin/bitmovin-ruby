require "spec_helper"

def test_resource_methods(klass, path, resources)
  describe klass do
    describe "finder methods" do
      subject { klass }
      it "should respond to .list()" do
        expect(subject).to respond_to(:list).with(0..2).arguments
      end
      describe "list()" do
        subject{ klass.list() }

        before(:each) do
          stub_request(:get, /.*#{path}.*/)
            .to_return(body: resources[:list].to_json)
        end
        it "should return a list" do
          expect(subject).to be_a(Array)
        end
        it "should return a list of S3Inputs" do
          expect(subject).to include(klass)
        end
      end

      it "should respond to .find(<encodingId>)" do
        expect(subject).to respond_to(:find).with(1).argument
      end
      describe "find()" do
        subject { klass.find(resources[:item][:id]) }

        before(:each) do
          stub_request(:get, /.*#{File.join(path, resources[:item][:id])}.*/)
            .to_return(body: resources[:detail].to_json)
        end

        it "should call GET #{path}/<id>" do
          expect(subject).to have_requested(:get, /.*#{File.join(path, resources[:item][:id])}.*/)
        end

        it "should return a S3Input" do
          expect(subject).to be_a(klass)
        end

        it "should be initialized with correct values from response" do
          expect(klass).to receive(:new).with(resources[:item])
          subject
        end
      end
    end

    describe "instance methods" do
      subject { klass.new(resources[:item]) }

      describe 'new' do
        it "should initialize all properties from hash" do
          expect(subject.id).to eq(resources[:item][:id])
          expect(subject.name).to eq(resources[:item][:name])
          expect(subject.description).to eq(resources[:item][:description])
        end

        it "can initialize new object" do
          expect{ klass.new }.to_not raise_error
        end

        it "can initialize ruby style hash" do
          expect { klass.new({ created_at: 'bucket' }) }.to_not raise_error
          expect(klass.new({ created_at: 'bucket' }).created_at).to eq('bucket')
        end
      end

      it "should respond to .delete!" do
        expect(subject).to respond_to(:delete!).with(0).arguments
      end

      describe "delete!()" do
        before(:each) do
          stub_request(:delete, /.*#{File.join(path, resources[:item][:id])}.*/)
        end
        it "should call DELETE #{path}/<id>" do
          expect(subject.delete!).to have_requested(:delete, /.*#{File.join(path, resources[:item][:id])}.*/)
        end
      end

      it "should respond to .save!()" do
        expect(subject).to respond_to(:save!).with(0).arguments
      end

      describe "save!" do

        context "without id set" do
          let!(:body) do
            dup = resources[:item].dup
            dup.delete(:id)
            dup
          end
          subject do 
            klass.new(body)
          end

          it "should call POST #{path}" do
            stub_request(:post, /.*#{path}/)
              .with(body: body.to_json)
              .to_return(body: response_envelope({ id: 'foo' }).to_json)
            expect(subject.save!).to have_requested(:post, /.*#{path}/)
          end

          it "should send body" do
            stub_request(:post, /.*#{path}/)
              .with(body: body.to_json)
              .to_return(body: response_envelope({ id: 'foo' }).to_json)
            expect(subject.save!).to have_requested(:post, /.*#{path}/).with(body: body.to_json)
          end

          it "should call block with json response" do
            resp = response_envelope({ id: 'foo' }).to_json
            stub_request(:post, /.*#{path}/)
              .with(body: body.to_json)
              .to_return(body: resp)

            called = false
            callback = Proc.new do |f|
              called = true
              expect(f).to eq(resp)
            end
            subject.save!(&callback)
            expect(called).to eq(called)
          end
        end

        context "with id set" do
          subject { klass.new(resources[:item]) }
          it "should raise an error if id is set" do
            expect{ subject.save! }.to raise_error(BitmovinError)
          end
        end
      end

      describe "inspect" do
        it "should output #{klass.name}(id, name)" do
          expect(subject.inspect).to eq("#{klass.name}(id: #{resources[:item][:id]}, name: #{resources[:item][:name]})")
        end
      end
    end
  end
end
