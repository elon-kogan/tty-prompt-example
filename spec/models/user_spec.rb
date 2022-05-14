# frozen_string_literal: true

describe User, type: :model do
  let(:correct_password) { 'some password' }
  let(:attributes) { { name: 'John', password: 'some password' } }
  subject { described_class.new(attributes) }

  context('when attributes are valid') { it { is_expected.to be_valid } }

  context 'when name is not present' do
    before { attributes.delete(:name) }
    it { is_expected.not_to be_valid }
  end

  context 'when name is blank' do
    before { attributes[:name] = '' }
    it { is_expected.not_to be_valid }
  end

  context 'when password is not present' do
    before { attributes.delete(:password) }
    it { is_expected.not_to be_valid }
  end

  context 'when password is blank' do
    before { attributes[:password] = '' }
    it { is_expected.not_to be_valid }
  end

  describe '#authenticate' do
    subject { described_class.new(attributes).authenticate(current_password) }

    context('when password is correct') do
      let(:current_password) { correct_password }

      it { is_expected.to be_truthy }
    end

    context('when password is incorrect') do
      let(:current_password) { 'incorrect password' }

      it { is_expected.to be_falsey }
    end
  end
end
