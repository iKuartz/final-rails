class V1::LoginController < ApplicationController
  def generate_user_token(name)
    user = User.find_by! name: name
    payload = {
      name: user.name
    }
    token = JsonWebToken.encode payload
    render json: {
      token:
    }, status: 200
  end

  def index
    name = params[:name]
    begin
      generate_user_token name
    rescue ActiveRecord::RecordNotFound
      render json: {
        message: 'Error logging in',
        error: 'User not present'
      }, status: 404
    end
  end

  def create_new_record(parameters)
    User.create! parameters
    render json: {
      message: 'User Created Successfully'
    }, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: 'Error saving user to database',
      error: e.record.errors
    }, status: 500
  end

  def create
    parameters = register_params
    begin
      User.find_by! name: parameters[:name]
      render json: {
        message: 'Error saving user to database',
        error: 'User already registered'
      }, status: 500
    rescue ActiveRecord::RecordNotFound
      create_new_record parameters
    end
  end

  def register_params
    params.require(:user).permit(:name)
  end
end
