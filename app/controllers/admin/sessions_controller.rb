# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    admin_items_path
  end
 
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute_to_permit])
  end
  #def new
  #end
  
  #def create
  #end
  
  #def destroy
  #end  
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
    #def create
     #super
    #end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
