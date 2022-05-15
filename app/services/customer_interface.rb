# frozen_string_literal: true

class CustomerInterface
  class BackException < StandardError; end

  def call
    @prompt = TTY::Prompt.new
    @wallet = []
    @wallet_sum = 0
    @product = ask_product
    ask_coins
    sell_product
  rescue BackException, ActiveRecord::Rollback
    give_money
    :back
  end

  private

  attr_reader :prompt, :product, :wallet, :wallet_sum

  def ask_product
    prompt.select('What product would you like to buy?', product_options, per_page: 5)
          .tap do |selected|
      raise BackException if selected == :back
    end
  end

  def ask_coins
    loop do
      new_coin = ask_coin
      wallet.push(new_coin)
      @wallet_sum += new_coin.amount
      break if enough_money?
    end
  end

  def ask_coin
    message = "What coin would you like to insert? (inserted #{wallet_sum})"
    prompt.select(message, coin_options).tap do |selected|
      raise BackException if selected == :back
    end
  end

  def sell_product
    ActiveRecord::Base.transaction do
      add_coins_from_wallet
      give_product
      prompt.ok("#{product.label} costs #{product.price}; You paid #{wallet_sum}")

      give_out_change
    end
  end

  def add_coins_from_wallet
    wallet.each { |coin| coin.count += 1 }
    wallet.uniq.each(&:save!)
  end

  def give_product
    product.update!(count: product.count - 1)
  end

  def give_out_change
    count_change.each { |coin| coin.count -= 1 }
    count_change.uniq.each(&:save!)

    give_money(current_wallet: count_change, key: 'change')
  end

  def enough_money?
    wallet_sum >= product.price
  end

  def give_money(current_wallet: wallet, key: 'money')
    return if current_wallet.blank?

    message = "Don't forget your #{key}:"
    filtered_wallet = current_wallet.each_with_object({}) do |coin, result|
      result[coin.label] ||= 0
      result[coin.label] += 1
    end
    filtered_wallet.each { |label, count| message += " #{label} * #{count};" }
    prompt.warn(message)
  end

  def count_change
    @count_change ||= ChangeCounter.new(amount: wallet_sum - product.price).call
  end

  def coin_options
    return @coin_options if @coin_options.present?

    @coin_options = Coin.all.inject({}) { |result, coin| result.merge(coin.label.to_s => coin) }
    @coin_options['<= Back'] = :back
    @coin_options
  end

  def product_options
    return @product_options if @product_options.present?

    @product_options = Product.all.map do |product|
      result = { name: "#{product.label} (costs #{product.price})", value: product }
      result[:disabled] = '(out of stock)' if product.count == 0
      result
    end
    @product_options.push(name: '<= Back', value: :back)
    @product_options
  end
end
