class ApplicationController < ActionController::API
  respond_to :json
  before_action :update_allowed_parameters, if: :devise_controller?

  def secret_key
    Rails.application.secret_key_base
  end

  def token
    request.headers['Authorization'].split[1]
  end

  def issue_token(user)
    JWT.encode({ id: user.id, exp: 1.month.from_now.to_i }, Rails.application.secret_key_base)
  end

  def decoded_token
    JWT.decode(token, secret_key)[0]
  rescue JWT::ExpiredSignature
    render json: { error: 'Token expired!' }, status: :unauthorized
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { error: 'Verification of token failed!' }, status: :unauthorized
  end

  def authenticate_user!(_ = {})
    render json: { error: 'Must be logged in' }, status: :unauthorized unless logged_in?
  end

  def current_user
    @current_user ||= User.find_by(id: decoded_token['id'])
  end

  def logged_in?
    current_user.present?
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Resource not found!' }, status: :not_found
  end

  rescue_from ActionController::RoutingError do
    render json: { error: 'bad route' }, status: :not_found
  end

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :username, :email, :password) }
  end
end
