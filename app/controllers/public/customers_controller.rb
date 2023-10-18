class Public::CustomersController < ApplicationController

  def show
    @customer = current_customer
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:update]="お客様の情報更新に成功しました。"
      redirect_to customers_mypage_path(@customer.id)
    else
     render  'edit'
    end 
  end

  def check
  end

  def withdraw
    @customer = Customer.find(current_customer.id)
    # is_activeカラムをtrueに変更することにより削除フラグを立てる
    @customer.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path

  end

  private

  def customer_params
    params.require(:customer).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :post_code, :address, :telephone_number)
  end


end
