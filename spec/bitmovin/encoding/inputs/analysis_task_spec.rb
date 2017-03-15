require "spec_helper"

describe Bitmovin::Encoding::Inputs::AnalysisTask do
  subject { Bitmovin::Encoding::Inputs::AnalysisTask.new('input-id', 'analysis-id') }

  it { should respond_to(:input_id) }
  it { should respond_to(:id) }
  it { should respond_to(:result) }
  it "should return given input_id" do
    expect(subject.input_id).to eq('input-id')
  end

  it "should return given analysis_id as id" do
    expect(subject.id).to eq('analysis-id')
  end

  context "given an input object" do
    let(:input) { Bitmovin::Encoding::Inputs::S3Input.new(id: 'test') }
    subject { Bitmovin::Encoding::Inputs::AnalysisTask.new(input, 'analysis-id') }

    it 'should set input-id from input object' do
      expect(subject.input_id).to eq(input.id)
    end

    it "should respond to input" do
      expect(subject).to respond_to(:input)
    end

    it "should return input" do
      expect(subject.input).to eq(input)
    end

    it "should respond to status" do
      expect(subject).to respond_to(:status)
    end

    describe "status call" do
      let(:status) { "RUNNING" }
      before(:each) do
        stub_request(:get, /.*#{"/v1/encoding/inputs/test/analysis/analysis-id/status"}/)
          .to_return(body: response_envelope({
            analysis: {
              status: status,
              eta: 67,
              progress: 36
            }
        }).to_json)
      end
      it "should call GET /v1/encoding/inputs/<input_id>/analysis/<analysis_id>/status" do
        expect(subject.status).to have_requested(:get, /.*#{"/v1/encoding/inputs/test/analysis/analysis-id/status"}/)
      end
      it "should return status as object" do
        expect(subject.status).to be_a(Object)
        expect(subject.status).to respond_to(:status)
        expect(subject.status).to respond_to(:eta)
        expect(subject.status).to respond_to(:progress)
      end

      it "should cache status for 5 seconds" do
        expect(Bitmovin.client).to receive(:get).and_call_original
        subject.status
        subject.status
      end

      it { should respond_to(:created?) }
      it { should respond_to(:queued?) }
      it { should respond_to(:running?) }
      it { should respond_to(:finished?) }
      it { should respond_to(:error?) }
      it { should respond_to(:eta?) }
      it { should respond_to(:progress?) }

      describe "status is CREATED" do
        let(:status) { "CREATED" }

        it "created? should return true" do
          expect(subject.created?).to eq(true)
        end
        it "queued? should return false" do
          expect(subject.queued?).to eq(false)
        end
        it "running? should return false" do
          expect(subject.running?).to eq(false)
        end
        it "finished? should return false" do
          expect(subject.finished?).to eq(false)
        end
        it "error? should return false" do
          expect(subject.error?).to eq(false)
        end
      end

      describe "status is QUEUED" do
        let(:status) { "QUEUED" }

        it "created? should return false" do
          expect(subject.created?).to eq(false)
        end
        it "queued? should return true" do
          expect(subject.queued?).to eq(true)
        end
        it "running? should return false" do
          expect(subject.running?).to eq(false)
        end
        it "finished? should return false" do
          expect(subject.finished?).to eq(false)
        end
        it "error? should return false" do
          expect(subject.error?).to eq(false)
        end
      end

      describe "status is RUNNING" do
        let(:status) { "RUNNING" }

        it "created? should return false" do
          expect(subject.created?).to eq(false)
        end
        it "queued? should return false" do
          expect(subject.queued?).to eq(false)
        end
        it "running? should return true" do
          expect(subject.running?).to eq(true)
        end
        it "finished? should return false" do
          expect(subject.finished?).to eq(false)
        end
        it "error? should return false" do
          expect(subject.error?).to eq(false)
        end
      end

      describe "status is FINISHED" do
        let(:status) { "FINISHED" }

        it "created? should return false" do
          expect(subject.created?).to eq(false)
        end
        it "queued? should return false" do
          expect(subject.queued?).to eq(false)
        end
        it "running? should return false" do
          expect(subject.running?).to eq(false)
        end
        it "finished? should return true" do
          expect(subject.finished?).to eq(true)
        end
        it "error? should return false" do
          expect(subject.error?).to eq(false)
        end
      end

      describe "status is ERROR" do
        let(:status) { "ERROR" }

        it "created? should return false" do
          expect(subject.created?).to eq(false)
        end
        it "queued? should return false" do
          expect(subject.queued?).to eq(false)
        end
        it "running? should return false" do
          expect(subject.running?).to eq(false)
        end
        it "finished? should return false" do
          expect(subject.finished?).to eq(false)
        end
        it "error? should return true" do
          expect(subject.error?).to eq(true)
        end
      end

      describe "eta?" do
        it "should return number from status call" do
          expect(subject.eta?).to eq(67)
        end
      end
      describe "progress?" do
        it "should return number from status call" do
          expect(subject.progress?).to eq(36)
        end
      end

      describe "result" do
        context "status is queued" do
          let(:status) { "QUEUED" }
          it "should raise error if status is not FINISHED" do
            expect { subject.result }.to raise_error(BitmovinError)
          end
        end
        context "with finished status" do
          let(:status) { "FINISHED" }
          it "should return analysis detail" do
            analysis_double = instance_double("Analysis")
            expect(Bitmovin::Encoding::Inputs::Analysis).to receive(:new).with(input.id).and_return(analysis_double)
            expect(analysis_double).to receive(:find).with(subject.id).and_return('foo')
            expect(subject.result).to eq('foo')
          end
        end
      end
    end
  end

end
