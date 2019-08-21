class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_seceret_code_is_invalid, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    flash[:warning] = "Invalid Session"
    redirect_to root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :secret_code])
    devise_parameter_sanitizer.permit(:account_update, keys: [:last_name, :first_name])
  end

  private

  def redirect_if_seceret_code_is_invalid
    if params[:user].try(:key?, :secret_code)
      secure_code_is_invalid = SecretCode.available.pluck(:code).exclude?(params[:user][:secret_code])
      if (params[:user][:secret_code].blank? || secure_code_is_invalid)
        redirect_to new_user_session_path, :alert => "Invalid Code"
      end
    end
  end

end