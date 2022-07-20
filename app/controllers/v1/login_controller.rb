class V1::LoginController < ApplicationController
  def index
    name = params[:name]
    users = User.all
    user_present = false
    users.each do |user|
      next unless user.name == name

      payload = {
        name:
      }
      secret = Rails.application.secret_key_base.to_s
      token = JWT.encode payload, secret, 'HS256'
      render json: {
        token:
      }, status: 200
      user_present = true
      break
    end

    return if user_present

    render json: {
      message: 'Error logging in',
      error: 'User not present'
    }, status: 404
  end

  def create
    users = User.all
    user_present = false
    users.each do |user|
      next unless user.name == register_params[:name]

      render json: {
        message: 'Error saving user to database',
        error: 'User already registered'
      }, status: 500
      user_present = true
      break
    end

    return if user_present

    user = User.create(register_params)
    if user.new_record?
      render json: {
        message: 'Error saving user to database',
        error: user.errors[:name]
      }, status: 500
    else
      render json: {
        message: 'User Created Successfully'
      }, status: 200
    end
  end

  def register_params
    params.require(:user).permit(:name)
  end
end
