require 'spec_helper'

describe UseCase::Succeedable do
  let(:klass) {
    Class.new {
      include UseCase
      param_key 'sign_up'

      def initialize(options)
        @success = options.fetch(:success, true)
      end

      def perform
        if @success
          success
        else
          failure
        end
      end
    }
  }
  subject(:test) { klass.new(params) }

  let(:subscriber) {
    Class.new do
      def sign_up_success(args = nil)
        @called ||= 0
        @called += 1
      end

      def called?
        @called
      end

      def called_count
        @called
      end
    end.new
  }
  let(:params) { {} }

  context 'subscriptions' do
    it 'allows global subscriptions' do
      klass.subscribe(subscriber)
      test.perform
      expect(subscriber).to be_called
    end

    it 'allows block subscriptions' do
      test.on_success do
        @success_called = true
      end
      test.perform
      expect(@success_called).to eq true
    end
  end

  context "when success or failure isn't indicated" do
    it { should be_success }
    it { should_not be_failed }
  end

  context "when marked as successful" do
    let(:params) { { success: true } }
    before { test.perform }

    it { should be_success }
    it { should_not be_failed }
  end

  context "when marked as failed" do
    let(:params) { { success: false } }
    before { test.perform }

    it { should_not be_success }
    it { should be_failed }
  end
end
