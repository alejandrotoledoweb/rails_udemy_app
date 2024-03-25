class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  protect_from_forgery
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  # def user_not_authorized #pundit
  #   redirect_to (request.referrer || courses_path), alert: "You are not authorized to perform this action."
  # end

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to (request.referrer || courses_path), alert: "You are not authorized to perform this action." }
      format.json { render json: { error: "You are not authorized to perform this action." }, status: :forbidden }
      format.js   { head :forbidden } # or render a JS response if needed
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
