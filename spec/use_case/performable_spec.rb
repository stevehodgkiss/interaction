require 'spec_helper'

describe UseCase do
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

  describe '#failure' do
    let(:use_case_class) {
      Class.new do
        include UseCase
        param_key 'sign_up'

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

    it 'halts execution of the use case' do
      use_case = use_case_class.perform
      expect(use_case).to_not be_performed
    end

    it 'marks the use case as failed' do
      use_case = use_case_class.perform
      expect(use_case).to_not be_success
    end
  end
end
