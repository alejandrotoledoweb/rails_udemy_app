class UsersController < ApplicationController
  before_action :set_user, only: %i[edit show update]

  def index
    # @users = User.all.order(created_at: :desc)

    @q = User.ransack(params[:q])
    # @users = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @users = pagy(@q.result(distinct: true).order(created_at: :desc))
    authorize @users
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    if @user.destroy
      redirect_to users_path, notice: "User was successfully deleted."
    else
      redirect_to users_path, alert: "Error deleting user."
    end
  end

  def edit
    authorize @user
    # @user = User.find(params[:id])
  end

  def send_email
    user = User.find(params[:id])
    RegistrationMailer.test_email(user).deliver_now
    redirect_to users_path, notice: "Email sent successfully!"
  end

  def show
  end

  def update
    begin
      if @user.update(user_params)
        redirect_to users_path, notice: "User updated successfully."
      else
        redirect_to edit_user_path(@user), alert: "At least one role is needed."
      end
    rescue ActionController::ParameterMissing => _e
      redirect_to edit_user_path(@user), alert: "At least one role is needed."
    end
  end

  def delete_confirmation
    @user = User.find(params[:id])
    respond_to do |format|
      format.html do
        render partial: "shared/confirmation_modal", locals: { user: @user }
      end
    end
  end

  def set_user
  Rails.logger.debug "Looking for user with ID: #{params[:id]}"
  @user = User.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "User not found."
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit({ role_ids: [] }, :avatar)
  end



end
