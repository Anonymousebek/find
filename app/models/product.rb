# typed: true

class Product < ApplicationRecord
  after_commit -> { broadcast_refresh_later_to "products"  }

  has_one_attached :image
  validates :title, :description, :image, presence: true
  validates :title, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validate :acceptable_image

  private
    def acceptable_image
      return unless image.attached?

      acceptable_formats = [ "image/gif", "image/png", "image/jpeg" ]

      unless acceptable_formats.include?(image.content_type)
        errors.add(:image, "must be a GIF, JPG or PNG image")
      end
    end
end
