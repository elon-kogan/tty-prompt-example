# frozen_string_literal: true

FactoryBot.define do
  factory :coin do
    sequence(:label) { |i| "Coin_#{i}" }
    sequence(:amount)
    count { 1 }
  end
end
