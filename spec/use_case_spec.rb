require 'spec_helper'

describe UseCase do
  describe '.perform' do
    let(:use_case_class) do
      Class.new do
        include UseCase.use_case
        set_model_name 'sign_up'

        def initialize(*args)
          @args = args
        end

        def perform
          @performed = true
        end

        def performed?
          @performed
        end

        attr_reader :args
      end
    end

    it 'returns the new use case' do
      use_case = use_case_class.perform
      expect(use_case).to be_instance_of(use_case_class)
    end

    it 'calls #perform' do
      use_case = use_case_class.perform
      expect(use_case).to be_performed
    end

    it 'passes on args to initialize' do
      use_case = use_case_class.perform(1, 2)
      expect(use_case.args).to eq [1, 2]
    end

    context "when success or failure isn't indicated" do
      subject(:use_case) { use_case_class.perform }

      it 'defaults to success' do
        expect(use_case).to be_success
        expect(use_case).to_not be_failed
      end
    end
  end

  describe '#failure' do
    let(:use_case_class) {
      Class.new do
        include UseCase.use_case
        set_model_name 'sign_up'

        def initialize(*args)
          @args = args
        end

        def perform
          failure(*@args)
          @performed = true
        end

        def performed?
          @performed
        end
      end
    }

    it 'halts execution of the use case' do
      use_case = use_case_class.perform
      expect(use_case).to_not be_performed
    end

    it 'marks the use case as failed' do
      use_case = use_case_class.perform
      expect(use_case).to_not be_success
    end
  end

  describe '#success' do
    let(:use_case_class) {
      Class.new do
        include UseCase.use_case
        set_model_name 'sign_up'

        def initialize(*args)
          @args = args
        end

        def perform
          success(*@args)
          @performed = true
        end

        def performed?
          @performed
        end
      end
    }
    subject(:test) { klass.new(params) }
    let(:params) { {} }

    it 'marks the use case as success' do
      use_case = use_case_class.perform
      expect(use_case).to be_success
    end
  end

  describe 'configuration options' do
    context 'without validations' do
      let(:use_case_class) {
        Class.new do
          include UseCase.use_case(validations: false)
        end
      }

      it "doesn't include ActiveModel::Validations" do
        expect(use_case_class.ancestors).to_not include(ActiveModel::Validations)
      end
    end

    context 'with validations' do
      let(:use_case_class) {
        Class.new do
          include UseCase.use_case(validations: true)
        end
      }

      it 'includes ActiveModel::Validations' do
        expect(use_case_class.ancestors).to include(ActiveModel::Validations)
      end
    end
  end
end
