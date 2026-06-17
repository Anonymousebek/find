class ChangeLineItemPriceDefault < ActiveRecord::Migration[8.1]
  def change
    change_column_null :line_items, :price, false
    change_column_default :line_items, :price, from: '0.01', to: nil
  end
end
