require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  private
    def single_resource_setup
      get cart_path
      @cart = Cart.find(session[:cart_id])
      @line_item = @cart.add_product(products(:dune))
      @line_item.save
    end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:dune).id }
    end

    follow_redirect!
    assert_response :success
    assert_select "h2", "Your Cart"
  end

  test "should add multiple items to the cart" do
    post line_items_path, params: { product_id: products(:dune).id }
    post line_items_path, params: { product_id: products(:dune).id }
    post line_items_path, params: { product_id: products(:hunger_games).id }

    cart = Cart.find(session[:cart_id])

    assert_equal 2, cart.line_items.length
    assert_equal 2, cart.line_items.find_by(product_id: products(:dune).id).quantity
    assert_equal 1, cart.line_items.find_by(product_id: products(:hunger_games).id).quantity
  end

  test "should add a product via turbo-stream" do
    assert_difference("LineItem.count") do
      post line_items_path, params: { product_id: products(:dune).id }, as: :turbo_stream
    end

    assert_response :success
    assert css_select(".line-item-highlight").present?
  end

  test "should update line_item" do
    single_resource_setup
    patch line_item_path(@line_item), params: { line_item: { product_id: @line_item.product.id, quantity: 5 } }
    @line_item.reload

    assert_equal 5, @line_item.quantity
    assert_redirected_to cart_url
  end

  test "should destroy line_item" do
    single_resource_setup

    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end
    assert_redirected_to cart_url
  end
end
