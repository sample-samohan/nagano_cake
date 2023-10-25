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

  def status_update
    @order = Order.find(params[:order][:id])
    if @order.update(params_int(order_params))
      flash[:success] = "制作ステータスを更新しました"
      status_is_deposited?(@order)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "注文ステータスの更新に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def production_status_update
    @order_detail = OrderDetail.find(params[:order_detail][:id])
    if @order_detail.update(params_int(order_detail_params))
      flash[:info] = "制作ステータスを更新しました"
      production_status_is_in_production?(@order_detail)
      @order =Order.find_by(id: params[:order_detail][:order_id])
      production_status_is_completion_of_production?(@order)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "制作ステータス更新に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end


 private

  def order_params
    params.require(:order).permit(:status)
  end

  def order_detail_params
    params.require(:order_detail).permit(:production_status, :id)
  end

  # 以下２つは、update時formから送られてくる値がデフォルトでstringなのでintegerに変換するためのもの。まずはそもそも整数にできるか調べる（Integer()で変換できれば数値、例外発生したら違う）
  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def params_int(order_params)
    order_params.each do |key, value|
      if integer_string?(value)
        order_params[key] = value.to_i
      end
    end
  end

   # 注文ステータスが「入金確認」になったら紐づく製作ステータス全てを「製作待ち」に自動更新
  def status_is_deposited?(order)
    if order.status_before_type_cast == 1
      order. order_details.each do |p|
        p.update(production_status: 1)
      end
      flash[:info] = "制作ステータスが制作待ちに更新されました"
    end
  end

  # 製作ステータスが全部「製作完了」になったら注文ステータスが「発送準備中」に自動更新
  def production_status_is_completion_of_production?(order)
    if order.order_details.all? do |p|
        p.production_status_before_type_cast == 3
      end
      order.update(status: 3)
      flash[:success] = "注文ステータスが「発送準備中に更新されました"
    end
  end

  # 製作ステータスが一つでも「製作中」になったら注文ステータスが「製作中」に自動更新
  def production_status_is_in_production?(order_detail)
    if order_detail.production_status_before_type_cast == 2
      order_detail.order.update(status: 2)
      flash[:success] = "注文ステータスが「制作中」に更新されました"
    end
  end

end

