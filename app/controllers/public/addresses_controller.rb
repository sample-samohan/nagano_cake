class Public::AddressesController < ApplicationController
   before_action :authenticate_customer!
 
 
  def index
    @address = Address.new
    @addresses = Address.all
  end

  def create
    address = Address.new(addresses_params)
    address.customer_id = current_customer.id
    if address.save
      flash[:success] = "配送先を登録しました"
      redirect_to addresses_path
    else
      flash[:danger] = "必要情報を入力してください"
      redirect_to addresses_path
    end  
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    if address.update(addresses_params)
      flash[:success] = "編集を保存しました"
      redirect_to addresses_path
    else 
      @address = Address.find(params[:id])
      flash[:danger] = "必要情報を入力してください"
      render "customers/addresses/edit"
    end  
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    flash[:success] = "削除しました"
    redirect_to addresses_path
  end
  
  private
  
  def addresses_params
    params.require(:address).permit(:post_code, :address, :name)
  end
  
  
end
