class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
      user_response = @user.attributes
      user_response.delete('password_digest')

      render json: {user: user_response, token: token}, status: :created
    else
      render json: {error: "Invalid username or password"}
    end
  end

  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      user_response = @user.attributes
      user_response.delete('password_digest')


      render json: {user: user_response, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
