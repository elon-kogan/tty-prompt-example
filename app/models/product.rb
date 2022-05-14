# frozen_string_literal: true

class Product < ActiveRecord::Base
  validates :label, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :count, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
end
