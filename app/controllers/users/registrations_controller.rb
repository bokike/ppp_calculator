class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_params_exist, only: :create

  def create
    user = User.new user_params
      if user.save
        session[:user_id] = user.id
        p current_user
        render json: {
          messages: "Sign Up Successfully",
          is_success: true,
          data: {user: user}
        }, status: 200
      else
        render json: {
          messages: "Sign Up Failded, email already exist",
          is_success: false
        }, status: :unprocessable_entity
      end
  end

  private
    def user_params
      params.permit(:email, :password)
    end
  
    def ensure_params_exist
      return if params[:email].present? && params[:password]
      render json: {
          messages: "Missing Params",
          is_success: false,
          data: {}
        }, status: :bad_request
    end
end