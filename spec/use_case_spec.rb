require 'spec_helper'

describe UseCase do
  let(:use_case_class) do
    Class.new do
      include UseCase

      def perform(args = {})
        success = args.delete(:success)
        if success
          success
        else
          failure
        end
      end
    end
  end

  subject(:use_case) { use_case_class.new }

  context 'on success' do
    before do
      @result = use_case.perform(success: true)
    end

    it 'has succeeded' do
      expect(use_case).to be_success
    end

    it 'has not failed' do
      expect(use_case).to_not be_failed
    end

    it 'returns true' do
      expect(@result).to eq true
    end
  end

  context 'on failure' do
    before do
      @result = use_case.perform(success: false)
    end

    it 'has not succeeded' do
      expect(use_case).to_not be_success
    end

    it 'has failed' do
      expect(use_case).to be_failed
    end

    it 'returns false' do
      expect(@result).to eq false
    end
  end
end
