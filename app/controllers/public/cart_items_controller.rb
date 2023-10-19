class Public::CartItemsController < ApplicationController
  
  def create
    @cart_items = current_customer.cart_items.all
  end  
    
  def index
    @cart_items = CartItem.all
    @total_price = 0
    
  end

  def update
  end
  
  def destroy
  end
  
  def all_destroy
  end  
end
