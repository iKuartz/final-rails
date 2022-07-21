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

  def hotels_params
    params.require(:hotel).permit(:name, :description, :room, :pool, :bar, :air_conditioning, :tv, :gym, :reservation,
                                  :country, :state, :city, :neighbourhood, :street, :number, :complement)
  end

  def create
    token = params[:token]
    secret = Rails.application.secret_key_base.to_s
    begin
      decoded_token = JWT.decode token, secret, true, { algorithm: 'HS256' }
      username_from_token = decoded_token[0]['name']
      user = User.where(name: username_from_token).first
      parameters = hotels_params
      p parameters
      feature = Feature.create(room: parameters[:room], pool: parameters[:pool], bar: parameters[:bar],
                               air_conditioning: parameters[:air_conditioning],
                               tv: parameters[:tv], gym: parameters[:gym])
      if feature.new_record?
        render json: {
          error: 'Unable to save to the database[1x501]'
        }
        p feature.errors
      else
        address = Address.create(country: parameters[:country], state: parameters[:state], city: parameters[:city],
                                 neighbourhood: parameters[:neighbourhood], street: parameters[:street],
                                 number: parameters[:number], complement: parameters[:complement])
        if address.new_record?
          render json: {
            error: 'Unable to save to the database[1x502]'
          }
          feature.destroy
        else
          hotel = Hotel.create(name: parameters[:name], description: parameters[:description], feature: feature.id,
                               address: address.id, owner: user.id)
          if hotel.new_record?
            render json: {
              error: 'Unable to save to the database[1x503]'
            }
            feature.destroy
            address.destroy
          else
            render json: {
              message: 'Hotel created successfully'
            }
          end
        end
      end
    rescue JWT::DecodeError
      render json: {
        error: 'Invalid Token'
      }
    end
  end
end
