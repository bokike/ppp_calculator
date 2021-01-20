# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :get_user, only: :create

  def create
    user = User.find_by(email: params[:email])
    if user.valid_password?(params[:password])
      session[:user_id] = user.id
      render json: {
          messages: "Sign Up Successfully",
          is_success: true,
          data: {user: user}
        }, status: 200
    else
      render json: :unauthorized, status: 401
    end
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    session[:user_id] = nil
    head :no_content
  end

  def logged_in
    if session[:user_id]
      current_user = User.find(session[:user_id])
      render json: {
        logged_in: true,
        user: current_user
      }, status: 200
    else
      render json: {
        logged_in: false
      }, status: 401
    end
  end

  private
  def sign_in_params
    params.permit(:email, :password)
  end

  def get_user
    @user = User.find_by(email: params[:email])
    if @user
      return @user
    else 
      render json: 'user not found. unregistered user', status: 401
    end
  end
end
