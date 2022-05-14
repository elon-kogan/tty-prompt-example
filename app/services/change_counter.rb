# frozen_string_literal: true

class ChangeCounter
  def initialize(amount:)
    @amount = amount
  end

  def call
    init_wallet
    fill_matrix
    matrix[matrix.keys.max]
  end

  private

  attr_reader :amount, :matrix

  def init_wallet
    @matrix = { 0 => [] }
  end

  def fill_matrix
    coins.each do |coin|
      coin.count.times do
        matrix.keys.sort.each do |current_amount|
          try_to_add_coin(coin, current_amount)
        end
      end
    end
  end

  def try_to_add_coin(coin, current_amount)
    new_amount = current_amount + coin.amount
    return if new_amount > amount

    matrix[new_amount] = matrix[current_amount] + [coin] unless matrix.key?(new_amount)
  end

  def coins
    Coin.where('count > 0')
        .where('amount < ?', amount)
        .order(amount: :desc)
  end
end
