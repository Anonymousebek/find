class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: %i[ show update increment decrement destroy ]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item = @line_item }
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render store_index_url, notice: "Something went wrong when adding an item", status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to cart_url, status: :see_other }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render cart_url, status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  def increment
    @line_item.cart.add_product(@line_item.product)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to store_index_path, status: :see_other, notice: "Line Item quantity was increased." }
      format.json { head :no_content }
    end
  end

  def decrement
    if @line_item.quantity == 1
      @line_item.destroy!
    else
      @line_item.decrement! "quantity"
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to store_index_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_url, notice: "Line item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = @cart.line_items.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.expect(line_item: [ :product_id, :quantity ])
    end

    def record_not_found
      respond_to do |format|
        format.html { redirect_to cart_url, notice: "Item not found.", status: :see_other }
        format.json { render json: { error: "Item not found" } }
      end
    end
end
