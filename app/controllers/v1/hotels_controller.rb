class V1::HotelsController < ApplicationController
  def index
    token = params[:token]
    secret = Rails.application.secret_key_base.to_s
    begin
      JWT.decode token, secret, true, { algorithm: 'HS256' }
      hotels = Hotel.limit(limit).offset(params[:offset]).as_json(
        include: { feature: { except: %i[created_at updated_at] },
                   address: { except: %i[created_at
                                         updated_at] } }, except: %i[created_at updated_at feature_id address_id]
      )
      render json: {
        data: hotels
      }
    rescue JWT::DecodeError
      render json: {
        error: 'Invalid Token'
      }
    end
  end

  def create
    token = params[:token]
    secret = Rails.application.secret_key_base.to_s
    begin
      decoded_token = JWT.decode token, secret, true, { algorithm: 'HS256' }
      username_from_token = decoded_token[0]['name']
      user = User.where(name: username_from_token).first
      parameters = hotels_params
      feature = Feature.create(room: parameters[:room], pool: parameters[:pool], bar: parameters[:bar],
                               air_conditioning: parameters[:air_conditioning],
                               tv: parameters[:tv], gym: parameters[:gym])
      if feature.new_record?
        render json: {
          error: 'Unable to save to the database[1x501]',
          error_list: feature.errors.full_messages
        }, status: 500
      else
        address = Address.create(country: parameters[:country], state: parameters[:state], city: parameters[:city],
                                 neighbourhood: parameters[:neighbourhood], street: parameters[:street],
                                 number: parameters[:number], complement: parameters[:complement])
        if address.new_record?
          render json: {
            error: 'Unable to save to the database[1x502]',
            error_list: address.errors.full_messages
          }, status: 500
          feature.destroy
        else
          hotel = Hotel.create(name: parameters[:name], description: parameters[:description], feature_id: feature.id,
                               address_id: address.id, user_id: user.id)
          p hotel.errors
          if hotel.new_record?
            render json: {
              error: 'Unable to save to the database[1x503]',
              error_list: hotel.errors.full_messages
            }, status: 500
            feature.destroy
            address.destroy
          else
            render json: {
              message: 'Hotel created successfully'
            }, status: 200
          end
        end
      end
    rescue JWT::DecodeError
      render json: {
        error: 'Invalid Token'
      }, status: 500
    end
  end

  private

  def hotels_params
    params.require(:hotel).permit(:name, :description, :room, :pool, :bar, :air_conditioning, :tv, :gym, :reservation,
                                  :country, :state, :city, :neighbourhood, :street, :number, :complement)
  end

  def limit
    [
      params.fetch(:limit, 10).to_i,
      100
    ].min
  end
end
