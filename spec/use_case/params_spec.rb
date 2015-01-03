require 'spec_helper'

describe UseCase::Params do
  it 'defaults attributes to not required so that nil or the given type is an acceptable value' do
    params = Class.new do
      include UseCase::Params
      attribute :name, String
    end.new
    expect(params.name).to be_nil
  end

  it 'allows required to be set to true' do
    params = Class.new do
      include UseCase::Params
      attribute :name, String, required: true
    end
    expect { params.new }.to raise_error(Virtus::CoercionError)
  end

  it 'allows the active model name to be set' do
    params = Class.new do
      include UseCase::Params
      attribute :name, String
      param_key(:user)
    end
    expect(params.model_name).to eq 'user'
  end

  context 'type coercion' do
    let(:klass) {
      Class.new do
        include UseCase::Params

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
end
