# frozen_string_literal: true

describe Butler, type: :service do
  describe '#call' do
    let(:butler) { described_class.new }
    subject { butler.call }

    let(:prompt) { TTY::Prompt.new }

    before { allow(butler).to receive(:prompt).and_return(prompt) }

    it 'asks about customer' do
      expect(prompt).to receive(:yes?).ordered.with('Are you Customer?').and_return(true)
      subject
    end

    context 'when customer has arrived' do
      before { expect(prompt).to receive(:yes?).ordered.with('Are you Customer?').and_return(true) }
      it { is_expected.to eq(:customer) }
    end

    context 'when user has arrived' do
      let(:correct_password) { 'correct_password' }
      let(:user) { build_stubbed(:user, password: correct_password) }

      before do
        expect(prompt).to receive(:yes?).ordered.with('Are you Customer?').and_return(false)
        expect(prompt).to receive(:ask).ordered.with('Name?', any_args).and_return(passed_name)
        expect(prompt).to receive(:mask).ordered
                                        .with('Password?', any_args).and_return(passed_password)
      end

      context 'when it is existed user' do
        let(:passed_name) { user.name }
        before { expect(User).to receive(:find_by).with(name: user.name).and_return(user) }

        context 'when password is correct' do
          let(:passed_password) { correct_password }

          it { is_expected.to eq(user) }
        end

        context 'when password is incorrect' do
          let(:passed_password) { 'incorrect_password' }

          it 'shows wrong password message and starts from the beginning' do
            expect(prompt).to receive(:warn).ordered.with('Wrong password')
            subject
          end
        end
      end
    end
  end
end
