class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  after_commit -> {
    broadcast_replace_later_to self
  }

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)

    if current_item
      current_item.with_lock do
        current_item.update!(quantity: current_item.quantity + 1)
      end
    else
      current_item = line_items.build(product_id: product.id, price: product.price)
    end

    current_item
  end

  def total_price
    line_items.sum { |line_item| line_item.total_price }
  end
end
