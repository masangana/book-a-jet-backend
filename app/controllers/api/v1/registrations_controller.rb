class Api::V1::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(sign_up_params)
    if @user.save
      @token = issue_token(@user)
      render json: { token: @token, name: @user.name, email: @user.email, id: @user.id, photo: @user.photo },
             status: :ok
    else
      render json: { errors: 'Something is wrong, User registration failed' }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.permit(:name, :email, :username, :photo, :password)
  end
end
