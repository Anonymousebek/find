require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cart = carts(:one)
  end

  test "should show cart" do
    get cart_url
    assert_response :success
  end

  test "should destroy cart" do
    post line_items_url, params: { product_id: products(:dune).id }
    @cart = Cart.find(session[:cart_id])

    assert_difference("Cart.count", -1) do
      delete cart_url
    end

    assert_nil session[:cart_id], "session[:cart_id] should be nil"
    assert_redirected_to store_index_url, "User should be redirected to store#index"
  end
end
