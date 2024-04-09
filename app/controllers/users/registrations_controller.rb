# frozen_string_literal: true
# require 'pry'
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # prepend_before_action :check_captcha, only: %i[create]

  #  for recaptcha logic



  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource

  # def create
  #   success = verify_recaptcha(action: 'login', minimum_score: 0.5, secret_key: ENV['RECAPTCHA_SECRET_KEY'])
  #   if !success
  #     @show_checkbox_recaptcha = true
  #   end
  #   checkbox_success = verify_recaptcha unless success
  #   if success || checkbox_success
  #     # Perform action
  #     # super
  #   else
  #     if !success
  #       @show_checkbox_recaptcha = true
  #     end
  #     render 'new', alert: "reCAPTCAH error."
  #   end
  # end

  # def create
  #   @user = User.new(sign_up_params)
  #   if verify_recaptcha(model: @user) && @user.save
  #     super # Call the original Devise `create` method.
  #           # This is reached if reCAPTCHA is valid and the user is successfully saved.
  #           # It might be redundant here since `resource.save` is already called,
  #           # and typically you might redirect or modify the flow after your custom logic.
  #   else
  #     # Add custom error handling for reCAPTCHA failure or if user.save fails
  #     build_resource(sign_up_params)
  #     resource.validate
  #     set_minimum_password_length

  #     unless verify_recaptcha(model: @user)
  #       resource.errors.add(:base, "reCAPTCHA verification failed, please try again.")
  #     end

  #     respond_with resource
  #   end
  # end

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

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name, :email, :password, :password_confirmation, :current_password])
  end

  # Overriding the method to not require current password for OAuth users
  def update_resource(resource, params)
    # binding.pry
    unless params[:password].present? && params[:password_confirmation].present?
      resource.update_without_password(params.except("current_password"))
    else
      super
    end
    # if resource.provider? # Check if the user signed up via OAuth
    # else
      # super
    # end
  end

  private

  # def validate_form_captcha
  #   @user = User.new(sign_up_params)
  #   # binding.pry
  #   if verify_recaptcha(model: @user) && @user.save
  #     redirect_to root_path
  #   else
  #     render 'new', alert: "Failed to check recaptcha."
  #   end
  # end


  # end
  # def check_recaptcha
  #   unless verify_recaptcha
  #     self.resource = resource_class.new sign_up_params
  #     resource.validate
  #     set_minimum_password_length
  #     respond_with_navigational(resource) { render :new }
  #   end
  # end

  # def check_captcha
  #   return if verify_recaptcha # verify_recaptcha(action: 'signup') for v3

  #   self.resource = resource_class.new sign_up_params
  #   resource.validate # Look for any other validation errors besides reCAPTCHA
  #   set_minimum_password_length

  #   respond_with_navigational(resource) do
  #     flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
  #     render :new
  #   end
  # end
end
