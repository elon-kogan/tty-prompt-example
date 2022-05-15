# frozen_string_literal: true

describe Product, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) { { label: 'Half', price: 0.5 } }

  context('when attributes are valid') { it { is_expected.to be_valid } }

  context 'when count is positive' do
    before { attributes[:count] = 12 }

    it { is_expected.to be_valid }
  end

  context 'when count is negative' do
    before { attributes[:count] = -2 }

    it { is_expected.not_to be_valid }
  end

  context 'when label is not present' do
    before { attributes.delete(:label) }

    it { is_expected.not_to be_valid }
  end

  context 'when label is blank' do
    before { attributes[:label] = '' }

    it { is_expected.not_to be_valid }
  end

  context 'when price is not present' do
    before { attributes.delete(:price) }

    it { is_expected.not_to be_valid }
  end

  context 'when price is negative' do
    before { attributes[:price] = -0.2 }

    it { is_expected.not_to be_valid }
  end
end
