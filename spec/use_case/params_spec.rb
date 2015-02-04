require 'spec_helper'

describe UseCase::Params do
  it 'defaults attributes to not required so that nil or the given type is an acceptable value' do
    params = Class.new do
      include UseCase::Params
      attribute :name, String
    end.new
    expect(params.name).to be_nil
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
