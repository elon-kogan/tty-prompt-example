# frozen_string_literal: true

COMMANDS = {
  'Change count of product' => 'change_product_count',
  'Add new product' => 'add_new_product',
  'Remove product' => 'remove_product',
  'Back to main page' => 'back'
}.freeze

class UserInterface
  def call
    @prompt = TTY::Prompt.new
    ask_command
    return :back if command == 'back'

    process_command
  end

  private

  attr_reader :prompt, :command

  def ask_command
    @command = prompt.select('What do you want to do?', COMMANDS)
  end

  def process_command
    case command
    when 'change_product_count'
      change_product_count
    when 'add_new_product'
      add_new_product
    when 'remove_product'
      remove_product
    end
  end

  def change_product_count
    product = ask_product
    new_count = ask_product_count(label: product.label, count: product.count)
    product.update!(count: new_count)
  end

  def add_new_product
    label = ask_product_label
    return prompt.warn("#{label} already exists") if Product.where(label: label).exists?

    price = ask_product_price(label: label)
    count = ask_product_count(label: label)

    Product.create!(label: label, price: price, count: count)
  end

  def remove_product
    product = ask_product
    product.destroy! if prompt.yes?('Are you sure?', default: false)
  end

  def ask_product_count(label:, count: nil)
    question = "How much #{label}"
    question += " (#{count})" if count
    question += ' should it be? (0-20)'

    prompt.ask(question, convert: :int, required: true) do |q|
      q.in('0-20')
      q.messages[:range?] = '%{value} out of expected range %{in}'
    end
  end

  def ask_product
    options = Product.all.inject({}) do |result, product|
      result.merge("#{product.label} (#{product.count})" => product)
    end
    prompt.select('What product do would you like to change?', options, per_page: 5)
  end

  def ask_product_label
    prompt.ask('What is the name of product?', required: true)
  end

  def ask_product_price(label:)
    question = "What is the price of #{label}?"
    prompt.ask(question, convert: :float, required: true) do |q|
      q.in('0.5-100')
      q.messages[:range?] = '%{value} out of expected range %{in}'
    end
  end

  def products
    @products ||= Product.all
  end
end
