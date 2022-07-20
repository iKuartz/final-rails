class V1::HotelsController < ApplicationController
  def index
    token = params[:token]
    secret = Rails.application.secret_key_base.to_s
    begin
      JWT.decode token, secret, true, { algorithm: 'HS256' }
      render json: {
        data: [
          'Hotel 1'
        ]
      }
    rescue JWT::DecodeError
      render json: {
        error: 'Invalid Token'
      }
    end
  end
end
