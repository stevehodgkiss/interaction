require 'spec_helper'

describe UseCase::Params do
  it 'defaults attributes to not required so that nil or the given type is an acceptable value' do
    params = Class.new do
      include UseCase.params
      attribute :name, String
    end.new
    expect(params.name).to be_nil
  end

  it 'allows required to be set to true' do
    params = Class.new do
      include UseCase.params
      attribute :name, String, required: true
    end
    expect { params.new }.to raise_error(Virtus::CoercionError)
  end

  it 'allows the active model name to be set' do
    params = Class.new do
      include UseCase.params
      attribute :name, String
      set_model_name(:user)
    end
    expect(params.model_name).to eq 'user'
  end

  context 'type coercion' do
    let(:klass) {
      Class.new do
        include UseCase.params

        attribute :name, String
      end
    }

    it 'fails loudly when given an incorrect type' do
      expect {
        klass.new(name: [])
      }.to raise_error(Virtus::CoercionError)
    end

    it 'does not fail on nil or missing attributes' do
      expect {
        klass.new
      }.not_to raise_error
    end
  end

  describe 'configuration options' do
    context 'without validations' do
      let(:params_class) {
        Class.new do
          include UseCase.params(validations: false)
        end
      }

      it "doesn't include ActiveModel::Validations" do
        expect(params_class.ancestors).to_not include(ActiveModel::Validations)
      end
    end

    context 'with validations' do
      let(:params_class) {
        Class.new do
          include UseCase.params(validations: true)
        end
      }

      it 'includes ActiveModel::Validations' do
        expect(params_class.ancestors).to include(ActiveModel::Validations)
      end
    end
  end
end
