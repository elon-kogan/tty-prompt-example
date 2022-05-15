# frozen_string_literal: true

describe Butler, type: :service do
  describe '#call' do
    subject(:call_service) { service.call }

    let(:service) { described_class.new }
    let(:prompt) { TTY::Prompt.new }
    let(:is_customer) { true }

    before do
      allow(service).to receive(:prompt).and_return(prompt)
      allow(prompt).to receive(:yes?).with('Are you Customer?').and_return(is_customer)
    end

    it 'asks about customer' do
      call_service
      expect(prompt).to have_received(:yes?).with('Are you Customer?')
    end

    context('when customer has arrived') { it { is_expected.to eq(:customer) } }

    context 'when user has arrived' do
      let(:is_customer) { false }
      let(:user) { build_stubbed(:user, password: correct_password) }
      let(:founded_user) { user }
      let(:correct_password) { 'correct_password' }
      let(:passed_password) { correct_password }
      let(:passed_name) { 'user name' }

      before do
        allow(prompt).to receive(:ask).with('Name?', any_args).and_return(passed_name)
        allow(prompt).to receive(:mask).with('Password?', any_args).and_return(passed_password)
        allow(User).to receive(:find_by).with(name: passed_name).and_return(founded_user)
        allow(prompt).to receive(:warn).and_return(true)
      end

      context 'when name and password are correct' do
        it('responds user successfully') { expect(call_service).to eq(user) }

        it('does not sow error') do
          call_service
          expect(prompt).not_to have_received(:warn)
        end
      end

      context 'when there is no user with passed name' do
        let(:founded_user) { nil }

        it 'shows wrong password message' do
          call_service
          expect(prompt).to have_received(:warn).with('Wrong password')
        end
      end

      context 'when password is incorrect' do
        let(:passed_password) { 'incorrect_password' }

        it 'shows wrong password message' do
          call_service
          expect(prompt).to have_received(:warn).with('Wrong password')
        end
      end
    end
  end
end
