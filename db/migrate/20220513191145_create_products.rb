# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :label, null: false, index: { unique: true }
      t.decimal :price, null: false
      t.integer :count, null: false, default: 0
      t.timestamps
    end
  end
end
