require 'spec_helper'
require 'active_model'

describe UseCase::ValidationHelpers do
  subject(:use_case) {
    Class.new {
      include UseCase
      include UseCase::ValidationHelpers
      include ActiveModel::Validations

      def self.model_name
        ActiveModel::Name.new(self, nil, "Test")
      end

      attr_accessor :name
      validates :name, presence: true

      def perform
        validate!
      end

      public :merge_errors
    }.new(params)
  }
  let(:params) { {} }

  describe '#merge_errors' do
    let(:object) { double(errors: errors) }
    let(:errors) { ActiveModel::Errors.new(Object.new) }

    before do
      errors.add(:name, 'Test error')
    end

    it 'merges errors from the given object' do
      use_case.merge_errors(object)
      expect(use_case.errors[:name]).to eq ['Test error']
    end
  end

  describe '#validate' do
    before { use_case.perform }

    context 'when validation fails' do
      let(:params) { {} }

      it { should_not be_success }
    end

    context 'when validation succeeds' do
      let(:params) { { name: 'Test' } }

      it { should be_success }
    end
  end
end
