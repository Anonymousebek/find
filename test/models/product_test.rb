# typed: true

require "test_helper"

def new_product(filename, content_type)
  Product.new(
    title: "Test",
    description: "Test",
    price: 1
  ).tap do |product|
    product.image.attach(
      io: File.open("test/fixtures/files/#{filename}"), filename:, content_type:
    )
  end
end

class ProductTest < ActiveSupport::TestCase
  test "all product attributes must present" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image].any?
  end

  test "product price should be positive" do
    product = Product.new(title: "Test", description: "test")
    product.image.attach(io: File.open("test/fixtures/files/dune.jpg"), filename: "test.jpg", "content_type": "image/jpeg")

    product.price = BigDecimal("-1")
    assert product.invalid?
    assert product.errors[:price].any?

    product.price = BigDecimal("0")
    assert product.invalid?
    assert product.errors[:price].any?

    product.price = BigDecimal("1")
    assert product.valid?
  end

  test "product's image content type" do
    product_with_jpg_image = new_product("dune.jpg", "image/jpeg")
    assert product_with_jpg_image.valid?, "image/jpeg should be valid"

    product_with_png_img = new_product("hunger_games.png", "image/png")
    assert product_with_png_img.valid?, "image/png should be valid"

    product_with_gif_img = new_product("ruby_pickaxe_3.gif", "image/gif")
    assert product_with_gif_img.valid?, "image/gif should be valid"

    product_with_svg_image = new_product("svg_file.svg", "image/svg+xml")
    assert_not product_with_svg_image.valid?, "image/svg+xml should be invalid"
  end

  test "product isn't valid if a title is not unique" do
    product = Product.new(title: products(:dune).title, description: "test", price: 1)
    product.image.attach(io: File.open("test/fixtures/files/dune.jpg"), filename: "dune.jpg", content_type: "image/jpeg")

    assert product.invalid?
    assert_equal [ I18n.translate("errors.messages.taken") ], product.errors[:title]
  end

  test "should validate product title minimum length" do
    product = Product.new(title: "T", description: products(:dune).title, price: 1)
    product.image.attach(io: File.open("test/fixtures/files/dune.jpg"), filename: "dune.jpg", content_type: "image/jpeg")

    assert product.invalid?
    assert product.errors["title"].any?
  end

  test "should fail when product title is too short" do
    product = Product.new(title: "T", description: products(:dune).title, price: 1)
    product.image.attach(io: File.open("test/fixtures/files/dune.jpg"), filename: "dune.jpg", content_type: "image/jpeg")

    assert product.invalid?
    assert product.errors["title"].any?
  end

  test "should fail when product title is too long" do
    product = Product.new(
      title: "Long title abcdefghigklmnopqrstuvwxyzabcdefghigklmnopqrstuvwxyzabcdefghigklmnopqrstuvwxyz",
      description: products(:dune).title,
      price: 1
    )
    product.image.attach(io: File.open("test/fixtures/files/dune.jpg"), filename: "dune.jpg", content_type: "image/jpeg")

    assert product.invalid?
    assert product.errors["title"].any?
  end
end
