class LineItemsController < ApplicationController
  include CurrentCart
  include SessionCounter
  before_action :set_cart, only: %i[ create ]
  before_action :reset_counter, only: %i[ create ]
  before_action :set_line_item, only: %i[ show edit update destroy ]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.where(cart_id: session[:cart_id])
  end

  # GET /line_items/1 or /line_items/1.json
  def show
    redirect_to cart_url if @cart
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to cart_url, notice: "Item was successfully added to the Cart." }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, status: :see_other }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy!

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Line item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find_by!(id: params.expect(:id), cart_id: session[:cart_id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.expect(line_item: [ :product_id ])
    end

    def record_not_found
      respond_to do |format|
        format.html { redirect_to cart_path, notice: "Item not found.", status: :see_other }
        format.json { render json: { error: "Item not found" } }
      end
    end
end
