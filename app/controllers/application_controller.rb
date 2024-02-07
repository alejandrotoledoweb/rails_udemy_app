class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  protect_from_forgery
  before_action :authenticate_user!

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

end
