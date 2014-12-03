require 'spec_helper'

describe UseCase::FormObject do
  subject(:form) {
    Class.new {
      include UseCase::FormObject

      attribute :name, String
      attribute :email, String
    }.new(params_hash)
  }
  let(:params_hash) { { name: name, email: nil } }
  let(:name) { 'John Smith' }

  it 'allows nil values for virtus attributes' do
    expect(form.name).to eq name
    expect(form.email).to be_nil
  end

  context 'with bad input that is not coercible to the specified type' do
    let(:params_hash) { { name: ['a', 'b'] } }
    it 'throws an error' do
      expect { form }.to raise_error(Virtus::CoercionError)
    end
  end
end
