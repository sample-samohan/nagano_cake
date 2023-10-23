class Admin::OrderDetailsController < ApplicationController
  def update
     @order_detail = OrderDetail.find(params[:id])
     @order = @order_detail.order
     @order_details = @order.order_details
     @order_detail.update(order_detail_params)
     @production_statuses = @order_detail#.pluck(:production_status)
     #@order.update(status: "in_production") if @production_statuses.any?{|val| val == "in_production" }
     #@order.update(status: "waiting_for_production") if @production_statuses.all?{|val| val == "completion_of_production"}
     redirect_to admin_order_path(@order)
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:production_status)
  end

end


