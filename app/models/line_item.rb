class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  after_commit -> {
    broadcast_replace_later_to cart
  }

  def total_price
    price * quantity
  end
end
