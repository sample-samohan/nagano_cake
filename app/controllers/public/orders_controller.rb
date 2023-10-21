class Public::OrdersController < ApplicationController
  #before_action :order_is_valid,only:[:new, :confirm, :create]
  #before_action :authenticate_member!, only: [:new, :confirm, :create, :index, :show, :complete]
    
    def new
      @order = Order.new
      @customer = Customer.find(current_customer.id)
    end
    
    
  def confirm
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @shipping_cost = 800


    @selected_payment_method = params[:order][:payment_method]

    # 商品の合計額
    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.add_tax_non_taxed_price*cart_item.amount
    end
    @cart_items_price = ary.sum

    @billing_amount = @shipping_cost + @cart_items_price

    @address_type = params[:order][:address_type]
    case @address_type
    when "customer_address"
      @selected_address = current_customer.postal_code + " " + current_customer.address + " " + current_customer.last_name + current_customer.first_name
    when "registered_address"
      unless params[:order][:registered_address_id] == ""
        selected = Address.find(params[:order][:registered_address_id])
        @selected_address = selected.postal_code + " " + selected.address + " " + selected.name
      else
        flash.now[:notice] = "お届け先を選択してください"
        render :new
      end
    when "new_address"
      unless params[:order][:new_postal_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
        @selected_address = params[:order][:new_postal_code] + " " + params[:order][:new_address] + " " + params[:order][:new_name]
      else
        flash.now[:notice] = "お届け先を記入してください"
        render :new
      end
    end

  
    def create
      @order = Order.new
      @order.customer_id = current_customer.id
      @order.postage = 800
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.add_tax_non_taxed_price*cart_item.amount
      end
      @cart_items_price = ary.sum
      @order.total_amount= @order.postage + @cart_items_price
      @order.payment_method = params[:order][:payment_method]
      if @order.payment_method == "credit_card"
        @order.status = 1
      else
        @order.status = 0
      end
      
      address_type = params[:order][:address_type]
      case address_type
      when "member_address"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_costomer.family_name + current_cosuomer.first_name
      when "registered_address"
      Address.find(params[:order][:registered_address_id])
      selected = Address.find(params[:order][:registered_address_id])
      @order.post_code = selected.post_code
      @order.address = selected.address
      @order.name = selected.name
      when "new_address"
      @order.post_code = params[:order][:new_post_code]
      @order.address = params[:order][:new_address]
      @order.name = params[:order][:new_name]
      end
    
     if @order.save
      if @order.status == 0
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.add_tax_non_taxed_price, amount: cart_item.amount, making_status: 0)
        end
      else
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.add_tax_non_taxed_price, amount: cart_item.amount, making_status: 1)
        end
      end
      @cart_items.destroy_all
      redirect_to complete_orders_path
     else
      render :items
     end
    end    
    
    def index
      @orders = Order.where(member_id: current_member.id).order(created_at: :desc)
    end
    
    def show
     @order = Order.find(params[:id])
    @order_details= OrderDetail.where(order_id: @order.id)
    end 
    
    def complete
      
    end
    
    private

    def order_params
    params.require(:order).permit(:customer_id, :post_code, :address, :name, :payment_method, :status, :posttage, :total_amount)
    end
    
end 