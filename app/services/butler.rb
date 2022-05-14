# frozen_string_literal: true

class Butler
  def call
    @prompt = TTY::Prompt.new

    meet_guest
  end

  private

  attr_reader :prompt

  def meet_guest
    return :customer if prompt.yes?('Are you Customer?')

    authorize_user
  end

  def authorize_user
    name = prompt.ask('Name?', required: true)
    password = prompt.mask('Password?', required: true)

    user = User.find_by(name: name)&.authenticate(password)
    user.tap do |authenticated|
      prompt.warn('Wrong password') unless authenticated
    end
  end
end
