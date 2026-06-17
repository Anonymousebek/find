require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
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
    post line_items_url, params: { product_id: products(:dune).id }
    post line_items_url, params: { product_id: products(:dune).id }
    post line_items_url, params: { product_id: products(:hunger_games).id }

    cart = Cart.find(session[:cart_id])

    assert_equal 2, cart.line_items.length
    assert_equal 2, cart.line_items.find_by(product_id: products(:dune).id).quantity
    assert_equal 1, cart.line_items.find_by(product_id: products(:hunger_games).id).quantity
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to line_items_url
  end
end
