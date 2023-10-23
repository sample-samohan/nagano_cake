class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).per(8)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
    #商品の合計を算出
    @sum = 0
    @subtotals = @order_details.map { |order_detail| order_detail.price * order_detail.amount }
    @sum = @subtotals.sum
  end
  
  def update
   @order = Order.find(params[:id])
   @order_details = @order.order_details
   if @order.update(order_params)
      @order_details.update_all(production_status: "waiting_for_production") if @order.status == "confirmation of payment"
   end  
   redirect_back(fallback_location: root_path)

  end

 
 private

  def order_params
    params.require(:order).permit(:status)
  end

  
   

end