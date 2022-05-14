# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "John#{i}" }
    password { 'correct password' }
  end
end
