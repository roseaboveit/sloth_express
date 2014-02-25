class PurchasesController < ApplicationController

  def new
    @purchase = Purchase.new
  end

  def show
    @purchase = Purchase.find(params[:id])
    @total = 0
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @order_items = OrderItem.where(order_id: session[:order_id])
    attempt_save
  end

  private
  def purchase_params
    params.require(:purchase).permit(:email, :address, :name, :cc_number, :cvv, :zipcode, :expiration_month, :expiration_year, :order_id, :product_id)
  end

  def update_order_items
    @order_items.each do |order_item|
      order_item.product.stock -= order_item.quantity
      retire_empty(order_item)
      order_item.product.save
    end
  end

  def retire_empty(order_item)
    if order_item.product.stock == 0
      order_item.product.update(item_status: "retired")
    end
  end

  def update_order
    current_order.status = "paid"
    current_order.save
    session[:order_id] = nil
  end

  def attempt_save
    if @purchase.save
      update_order_items
      update_order
      redirect_to purchase_path(@purchase.id), notice: 'Thank you for your order!'
    else
      render :new, notice: 'Your order was not completed. Please try again!'
    end
  end
end