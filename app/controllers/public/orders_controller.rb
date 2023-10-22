class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :index, :show, :complete]

    def new
      @order = Order.new
    end

    def confirm
      @cart_items = CartItem.where(customer_id: current_customer.id)
      @postage = 800 #送料は800円で固定
      @selected_payment_method = params[:order][:payment_method]
      #商品合計額の計算
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.add_tax_non_taxed_price * cart_item.amount
      end
      @cart_items_price = ary.sum   
      @total_price = @postage + @cart_items_price
      @address_type = params[:order][:address_type]
        case @address_type
        when "customer_address"
          @selected_address = current_customer.post_code + " " + current_customer.address + " " + current_customer.family_name + current_customer.first_name

        when "registered_address"
          unless params[:order][:registered_address_id] == ""
          selected = Address.find(params[:order][:registered_address_id])
          @selected_address = selected.post_code + " " + selected.address + " " + selected.name
          else
            render :new
          end

        when "new_address"
          unless params[:order][:new_post_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
          @selected_address = params[:order][:new_post_code] + " " + params[:order][:new_address] + " " + params[:order][:new_name]
          else
            render :new
          end
        end
    end


    def create
      @order = Order.new(order_params)
      @order.customer_id = current_customer.id
      @order.postage = 800
      #@order.status == 0
      
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.add_tax_non_taxed_price*cart_item.amount
      end
      @cart_items_price = ary.sum
      @order.total_amount= @order.postage + @cart_items_price 
      @order.payment_method = params[:order][:payment_method]
      
      if @order.payment_method == "credit_card"
        @order.status = 0
      else
        @order.status = 1
      end

      address_type = params[:order][:address_type]
      case address_type
      when "customer_address"
        @order.post_code = current_customer.post_code
        @order.address = current_customer.address
        @order.name = current_customer.family_name + current_customer.first_name
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
        @cart_items.each do |cart_item|
          @orderdetail = OrderDetail.new
          @orderdetail.order_id = @order.id
          @orderdetail.item_id = cart_item.item.id
           @orderdetail.price = cart_item.item.add_tax_non_taxed_price
           @orderdetail.amount = cart_item.amount
           
          @orderdetail.save!
        end
        @cart_items.destroy_all
        redirect_to complete_orders_path
      
      #else
        #@cart_items.each do |cart_item|
         
        #end
      #end
      #@cart_items.destroy_all
      #redirect_to complete_orders_path
     else
        render :new
     end
    end

    def index
      @orders = current_customer.orders.all.page(params[:page]).per(5).order(created_at: :DESC)
    end

    def show
      @order = current_customer.orders.find(params[:id])
      @order_details= OrderDetail.where(order_id: @order.id)

    end 
    
    def complete
      
    end



    private

    def order_params
    params.require(:order).permit(:customer_id, :post_code, :address, :name, :payment_method, :status, :postage, :total_amount)
    end

end