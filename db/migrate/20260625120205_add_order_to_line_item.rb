# typed: true

class AddOrderToLineItem < ActiveRecord::Migration[8.1]
  def change
    add_reference :line_items, :order, null: true, foreign_key: true
    change_column_null :line_items, :cart_id, true
  end
end
