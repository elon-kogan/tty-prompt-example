# frozen_string_literal: true

User.create(name: 'admin', password: 'password')
[
  ['quarter', 0.25], ['half', 0.5], ['one', 1], ['two', 2], ['three', 3], ['five', 5]
].each do |label, amount|
  Coin.create(amount: amount, label: label, count: 10)
end

[
  ['Water', 2.5, 20], ['Cola', 15, 2], ['Mars', 10.25, 0], ['Snickers', 15, 4]
].each do |label, price, count|
  Product.create(label: label, price: price, count: count)
end
