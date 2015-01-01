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
  end
end
