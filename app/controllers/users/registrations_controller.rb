# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end
  def new
    @user = User.new
  end

  # POST /resource
  # def create
  #   super
  # end
  def create
    @user = User.new(sign_up_params)
    unless @user.valid?
      flash.now[:alert] = @user.errors.full_messages
      render :new and return
    end
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    @shipping_address = @user.build_shipping_address
    render :new_shipping_address
  end

  def complete_user
    @user = User.new(session["devise.regist_data"]["user"])
    @shipping_address = ShippingAddress.new(shipping_address_params)
    unless @shipping_address.valid?
      flash.now[:alert] = @shipping_address.errors.full_messages
      render :new_shipping_address and return
    end
    @user.build_shipping_address(@shipping_address.attributes)
    if @user.save
      sign_in(:user, @user)
    else
      render :new
    end
  end

  def after_update_path_for(resource)
    "/users/#{current_user.id}"
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def shipping_address_params
    params.require(:shipping_address).permit(:name_first, :name_last, :name_first_kana, :name_last_kana, :zipcode, :prefecture_id, :city, :street_address, :building, :phone_number)
  end

end
