class V1::LoginController < ApplicationController
  def index
    name = params[:name]
    users = User.all
    user_present = false
    users.each do |user|
      next unless user.name == name

      render json: {
        message: 'Login successful.'
      }
      user_present = true
      break
    end

    return if user_present

    render json: {
      message: 'User not present'
    }
  end

  def create
    p register_params
    p params
    user = User.create(register_params)
    if user.new_record?
      render json: {
        message: 'Error saving user to database',
        error: user.errors[:name]
      }
    else
      render json: {
        message: 'User Created Successfully'
      }
    end
  end

  def register_params
    params.require(:user).permit(:name)
  end
end
