require 'spec_helper'

describe UseCase do
  before { Wisper::GlobalListeners.clear }

  describe '.perform' do
    let(:use_case_class) do
      Class.new do
        include UseCase
        param_key 'sign_up'

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

      it 'publishes a global success event' do
        subscriber = double(sign_up_success: true)
        use_case_class.subscribe(subscriber)
        use_case_class.perform
        expect(subscriber).to have_received(:sign_up_success)
      end
    end
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

    context 'events' do
      before { Wisper::GlobalListeners.clear }

      it 'published a global failed event with given args' do
        subscriber = double(sign_up_failure: false)
        use_case_class.subscribe(subscriber)
        use_case = use_case_class.perform(:my_arg)
        expect(subscriber).to have_received(:sign_up_failure).with(:my_arg)
      end

      it 'publishes a local failed event with given args' do
        use_case = use_case_class.new(:my_arg)
        @called = false
        use_case.on_failure do |args|
          @called = true
          @args = args
        end
        use_case.perform
        expect(@called).to eq true
        expect(@args).to eq :my_arg
      end
    end
  end

  describe '#success' do
    let(:use_case_class) {
      Class.new do
        include UseCase
        param_key 'sign_up'

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

    context 'events' do
      before { Wisper::GlobalListeners.clear }

      it 'published a global success event with given args' do
        subscriber = double(sign_up_success: false)
        use_case_class.subscribe(subscriber)
        use_case = use_case_class.perform(:my_arg)
        expect(subscriber).to have_received(:sign_up_success).with(:my_arg)
      end

      it 'publishes a local success event with given args' do
        use_case = use_case_class.new(:my_arg)
        @called = false
        use_case.on_success do |args|
          @called = true
          @args = args
        end
        use_case.perform
        expect(@called).to eq true
        expect(@args).to eq :my_arg
      end
    end

  end
end
