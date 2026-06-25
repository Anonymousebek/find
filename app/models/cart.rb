class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  after_commit -> { broadcast_replace_later_to "cart" }

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)

    if current_item
      current_item.increment! "quantity"
    else
      current_item = line_items.build(product_id: product.id, price: product.price)
    end

    current_item
  end

  def total_price
    line_items.sum { |line_item| line_item.total_price }
  end
end
