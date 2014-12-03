require 'spec_helper'

describe UseCase::ValidationHelpers do
  subject(:use_case) {
    Class.new {
      include ActiveModel::Validations
      include UseCase::ValidationHelpers

      public :merge_errors
    }.new
  }
  let(:object) { double(errors: errors) }
  let(:errors) { ActiveModel::Errors.new(Object.new) }

  before do
    errors.add(:name, 'Test error')
  end

  describe '#merge_errors' do
    it 'merges errors from the given object' do
      use_case.merge_errors(object)
      expect(use_case.errors[:name]).to eq ['Test error']
    end
  end
end
