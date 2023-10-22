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
  end

  private

  def order_params
    params.require(:order).permit(:post_code, :address, :name, :payment_method, :status, :posttage, :total_amount)
  end

  def order_detail_params
    params.require(:order_detail).permit(:production_status, :id)
  end

end