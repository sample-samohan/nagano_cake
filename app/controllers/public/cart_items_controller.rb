class Public::CartItemsController < ApplicationController
   
  before_action :authenticate_customer!
   
   def create
    @cart_items = current_customer.cart_items.all 
    if cart_items_params[:amount] != ""
      if @cart_items.any? { |cart_item| cart_item.item_id == params[:cart_item][:id].to_i }
        @cart_item_already = CartItem.find_by(item_id: params[:cart_item][:id].to_i)
        @cart_item_already.amount += params[:cart_item][:amount].to_i
        @cart_item_already.save
        flash[:notice] = "カートに商品を入れました"
        redirect_to cart_items_path
      else
        @cart_item = CartItem.new(
          amount: params[:cart_item][:amount].to_i,
          item_id: params[:cart_item][:id].to_i,
          customer_id: current_customer.id
        )
        @cart_item.save
        flash[:notice] = "カートに商品を入れました"
        redirect_to cart_items_path
      end
    else
      flash[:danger] = "個数を入力してください"
      redirect_back(fallback_location: root_path)
    end
   end
   
  def index
    @cart_items = current_customer.cart_items.all
    @sum = 0
    @cart_items.each do |cart_item|
      @subtotal = (Item.find(cart_item.item_id).non_taxed_price * 1.1 * cart_item.amount).to_i
      @sum += @subtotal
    end
  end

  
  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.amount = params[:cart_item][:id]
    @cart_item.update(cart_items_params)
    flash[:notice] = '個数を変更しました'
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
  cart_item = CartItem.find_by(id: params[:id], customer_id: current_customer.id)

  if cart_item
    cart_item.destroy
    flash[:danger] = "カートから削除しました"
  else
    flash[:error] = "指定したカートアイテムが見つかりませんでした"
  end

  redirect_to cart_items_path
  end
  
  def destroy_all
    current_customer.cart_items.destroy_all
    flash[:danger] = "カートが空です"
    redirect_to cart_items_path
  end

  private

  def cart_items_params
    params.require(:cart_item).permit(:amount, :item_id)
  end

end
