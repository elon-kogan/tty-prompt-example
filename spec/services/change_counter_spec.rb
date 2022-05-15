# frozen_string_literal: true

describe ChangeCounter, type: :service do
  describe '#call' do
    subject(:call_service) { service.call }

    let(:service) { described_class.new(amount: passed_amount) }
    let(:passed_amount) { 20 }

    let(:quarters) { build_stubbed(:coin, label: 'quarter', amount: 0.25, count: 5) }
    let(:halfs) { build_stubbed(:coin, label: 'half', amount: 0.5, count: 5) }
    let(:ones) { build_stubbed(:coin, label: 'one', amount: 1, count: 5) }
    let(:twos) { build_stubbed(:coin, label: 'two', amount: 2, count: 5) }
    let(:threes) { build_stubbed(:coin, label: 'three', amount: 3, count: 5) }
    let(:fives) { build_stubbed(:coin, label: 'five', amount: 5, count: 5) }

    let(:all_coins) { [fives, threes, twos, ones, halfs, quarters] }

    before { allow(service).to receive(:coins).and_return(all_coins) }

    it 'returns change for passed amount by fives' do
      expect(call_service).to match(Array.new(4) { fives })
    end

    context 'when there are fewer fives than need' do
      let(:fives_count) { 2 }
      let(:expected_result) { [fives] + Array.new(5) { threes } }

      before { fives.count = fives_count }

      it 'returns change for passed amount' do
        expect(call_service).to match(expected_result)
      end
    end

    context 'when it is not possible to change the amount' do
      let(:passed_amount) { 20.15 }

      it 'returns change for nearest amount' do
        expect(call_service).to match(Array.new(4) { fives })
      end
    end

    context 'when there is not enough money for change' do
      let(:passed_amount) { 200 }
      let(:expected_result) do
        all_coins.map { |coin| Array.new(coin.count) { coin } }.flatten
      end

      it 'returns all coins' do
        expect(call_service).to match(expected_result)
      end
    end
  end
end
