require 'spec_helper'

describe UseCase::Params do
  it 'defaults attributes to not required so that nil or the given type is an acceptable value' do
    form = Class.new do
      include UseCase::Params
      attribute :name, String
    end.new
    expect(form.name).to be_nil
  end
end
