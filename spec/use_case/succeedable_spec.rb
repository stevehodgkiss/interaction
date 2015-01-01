require 'spec_helper'

describe UseCase::Succeedable do
  let(:klass) {
    Class.new {
      include UseCase
      param_key 'sign_up'

      def mark_success
        success
      end

      def mark_failure
        failure
      end
    }
  }
  subject(:test) { klass.new }

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

  context 'subscriptions' do
    it 'allows global subscriptions' do
      klass.subscribe(subscriber)
      test.mark_success
      expect(subscriber).to be_called
    end

    it 'allows block subscriptions' do
      test.on_success do
        @success_called = true
      end
      test.mark_success
      expect(@success_called).to eq true
    end
  end

  context "when success or failure isn't indicated" do
    it { should be_success }
    it { should_not be_failed }
  end

  context "when marked as successful" do
    before { test.mark_success }

    it { should be_success }
    it { should_not be_failed }
  end

  context "when marked as failed" do
    before { test.mark_failure }

    it { should_not be_success }
    it { should be_failed }
  end
end
