require 'spec_helper'

describe UseCase::Succeedable do
  subject(:test) {
    Class.new {
      include UseCase::Succeedable

      def mark_success
        success
      end

      def mark_failure
        failure
      end
    }.new
  }

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
