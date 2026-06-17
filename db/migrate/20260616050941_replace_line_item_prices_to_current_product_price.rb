class ReplaceLineItemPricesToCurrentProductPrice < ActiveRecord::Migration[8.1]
  def up
    LineItem.all.each do |line_item|
      line_item.price = line_item.product.price
      line_item.save!
    end
  end

  def down
    LineItem.all.each do |line_item|
      line_item.price = 0.01
      line_item.save!
    end
  end
end
