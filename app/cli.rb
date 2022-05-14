# frozen_string_literal: true

class Cli
  def init_machine
    loop do
      welcome

      case user
      when User
        user_interface
      when :customer
        customer_interface
      end
    end
  end

  private

  attr_reader :user

  def welcome
    @user = Butler.new.call
  end

  def user_interface; end

  def customer_interface; end
end
