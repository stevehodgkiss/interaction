require 'spec_helper'

describe UseCase do
  describe '.perform' do
    let(:use_case_class) do
      Class.new do
        include UseCase

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
        include UseCase

        def initialize(*args)
          @args = args
        end

        def perform
          failure
          @performed = true
        end

        def performed?
          @performed
        end
      end
    }
    subject(:use_case) { use_case_class.perform }

    it 'does not halt execution of the use case' do
      expect(use_case).to be_performed
    end

    it 'marks the use case as failed' do
      expect(use_case).to be_failed
      expect(use_case).to_not be_success
    end
  end

  describe '#failure!' do
    let(:use_case_class) {
      Class.new do
        include UseCase

        def initialize(*args)
          @args = args
        end

        def perform
          failure!
          @performed = true
        end

        def performed?
          @performed
        end
      end
    }
    subject(:use_case) { use_case_class.perform }

    it 'halts execution of the use case' do
      expect(use_case).to_not be_performed
    end

    it 'marks the use case as failed' do
      expect(use_case).to be_failed
      expect(use_case).to_not be_success
    end
  end

  context 'on exception' do
    let(:my_error) { Class.new(StandardError) }
    let(:use_case_class) {
      Class.new do
        include UseCase

        def perform
          raise RuntimeError
        end
      end
    }

    it "doesn't mark the use case as success" do
      use_case = use_case_class.new
      use_case.perform rescue RuntimeError
      expect(use_case).to_not be_success
    end
  end

  describe '#success' do
    let(:use_case_class) {
      Class.new do
        include UseCase

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
end
