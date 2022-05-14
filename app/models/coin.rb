# frozen_string_literal: true

class Coin < ActiveRecord::Base
  validates :label, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :count, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
end
