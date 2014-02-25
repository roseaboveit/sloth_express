class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      assign_cart_to_user
      sloth_king_exception
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to products_path, :notice => "Bye, Sloth Cadet, hope to see you soon!"
  end

  def create_order
    order = Order.find_by(order: params[:order][:id])
    unless session[:order_id]
      session[:order_id] = order.id
    end
  end 

  def assign_cart_to_user
    if session[:order_id]
      current_order.user_id = session[:user_id]
      current_order.save
    end
  end

  def sloth_king_exception
    unless current_user.username == "Sloth King"
        redirect_to products_path, :notice => "Welcome, Sloth Cadet #{user.username}! Your mission, should you choose to accept it, is to find the best in sloth themed products and values!"
    else
        redirect_to products_path, :notice => "All hail the Sloth King!"
    end
  end
end
