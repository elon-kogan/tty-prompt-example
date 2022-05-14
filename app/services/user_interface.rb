# frozen_string_literal: true

class UserInterface
  def call(user:)
    @prompt = TTY::Prompt.new
    @user = user
    ask_command
  end

  private

  attr_reader :prompt, :user

  def ask_command; end

  def receive_product; end

  def remove_product; end
end
