# frozen_string_literal: true

class CreateCoins < ActiveRecord::Migration[7.0]
  def change
    create_table :coins do |t|
      t.string :label, null: false, index: { unique: true }
      t.decimal :amount, null: false
      t.integer :count, null: false, default: 0
      t.timestamps
    end
  end
end
