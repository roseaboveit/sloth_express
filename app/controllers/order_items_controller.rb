class OrderItemsController < ApplicationController

  before_action :set_order_item, only: [:show, :edit, :update, :destroy]
  
  def new
    @order_item = OrderItem.new(order_item_params)
  end
  

  def create
    @product = Product.find(params[:product_id])
    check_product
  end

  def add_item_to_cart
    assign_values

    if @order_item.save
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def update
    if do_we_have_enough?(params[:order_item][:quantity].to_i) && @order_item.update(order_item_params)
      redirect_to order_path(@order_item.order)
    else
      redirect_to order_path(@order_item.order), :notice => "Sorry, we only have #{@order_item.product.stock}."
    end
  end

  def remove_item
    @order_item = OrderItem.find_by(order_id: current_order.id, product_id: params[:product_id])
    @order_item.destroy
    redirect_to order_path(current_order)
  end

  private

  def do_we_have_enough?(number_requested)
    number_requested <= @order_item.product.stock
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :user_id)
  end
  
  def order_item_params
     params.require(:order_item).permit(:product_id, :order_id, :quantity )
  end

  def assign_values
    @product = Product.find(params[:product_id])
    @order_item = OrderItem.new 
    @order_item.product = @product
    @order_item.order = @order
  end

  def check_product
    if @product.stock < 1
      redirect_to product_path(@product), notice: "This product is out of stock."
    else
      check_or_create_session
      add_item_to_cart
    end
  end

  def check_or_create_session
    if session[:order_id]
        @order = Order.find(session[:order_id])
    else
      @order = Order.create(user_id: session[:user_id])
      session[:order_id] = @order.id
    end
  end
end
