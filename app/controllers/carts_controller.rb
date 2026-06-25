class CartsController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: %i[ show destroy ]

  def show
  end

  def destroy
    if @cart.id == session[:cart_id]
      @cart.destroy!
      session[:cart_id] = nil
      @cart = nil
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to store_index_path, status: :see_other, notice: "Your cart is currently empty." }
      format.json { head :no_content }
    end
  end
end
