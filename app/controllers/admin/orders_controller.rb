class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @orders = Order.all#page(params[:page]).per(10)
  end  
 
  def show
    @order = Order.find(params[:id])
    @item_orders = @oreder.order_details.all
    #商品の合計を算出
    @sum = 0
    @subtotals = @item_orders.map { |order_detail| order_detail.price * order_detail.amount }
    @sum = @subtotals.sum
  end
  
  def update
  end

  private

  def order_params
    params.require(:order).permit(:post_code, :address, :name, :payment_method, :status, :posttage, :total_amount)
  end

  def order_detail_params
    params.require(:order_detail).permit(:production_status, :id)
  end

end