# frozen_string_literal: true

class CustomerInterface
  def call
    @prompt = TTY::Prompt.new
    ask_product
    ask_coins
    give_out_change
  end

  private

  attr_reader :prompt

  def ask_product; end

  def ask_coins; end

  def give_out_change; end
end
