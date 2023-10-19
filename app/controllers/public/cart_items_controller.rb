class Public::CartItemsController < ApplicationController
  
  def create
    @cart_items = current_customer.cart_items.all
  end  
    
  def index
  end

  def update
  end
  
  def destroy
  end
  
  def all_destroy
  end  
end
