class V1::ReservationController < ApplicationController
  def index
    render json: {
      status: 'Under Construction'
    }
  end

  def create
    token = request.headers['token']
    secret = Rails.application.secret_key_base.to_s

    begin
      decoded_token = JWT.decode token, secret, true, { algorithm: 'HS256' }
      decoded_username = decoded_token[0]['name']

    rescue JWT::DecodeError
      render json: {
        error: 'Invalid Token'
      }, status: 500
    end
  end

  def destroy
    render json: {
      status: 'Under Construction'
    }
  end

  private

  def reservation_params
    params.require(:reservation).permit(:reserved_rooms, :hotel_id, :start_date, :end_date)
  end
end
