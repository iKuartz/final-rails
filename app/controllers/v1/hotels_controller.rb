class V1::HotelsController < ApplicationController
  def index
    token = request.headers['token']
    secret = Rails.application.secret_key_base.to_s
    begin
      JWT.decode token, secret, true, { algorithm: 'HS256' }
      hotels = Hotel.includes(image_attachment: :blob).limit(limit).offset(params[:offset])
      hotels_list = hotels.map do |hotel|
        image_url = ''
        image_url = url_for(hotel.image) if hotel.image.attached?
        hotel.as_json(
          include: { feature: { except: %i[created_at updated_at] },
                     address: { except: %i[created_at
                                           updated_at] } }, except: %i[created_at updated_at feature_id address_id]
        ).merge(
          image_path: image_url
        )
      end
      render json: {
        data: hotels_list
      }
    rescue JWT::DecodeError
      render json: {
        error: 'Invalid Token'
      }, status: 500
    end
  end

  def create
    token = request.headers['token']
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
        }, status: 501
      else
        address = Address.create(country: parameters[:country], state: parameters[:state], city: parameters[:city],
                                 neighbourhood: parameters[:neighbourhood], street: parameters[:street],
                                 number: parameters[:number], complement: parameters[:complement])
        if address.new_record?
          render json: {
            error: 'Unable to save to the database[1x502]',
            error_list: address.errors.full_messages
          }, status: 501
          feature.destroy
        else
          hotel = Hotel.create(name: parameters[:name], description: parameters[:description], feature_id: feature.id,
                               address_id: address.id, user_id: user.id, image: parameters[:image])
          if hotel.new_record?
            render json: {
              error: 'Unable to save to the database[1x503]',
              error_list: hotel.errors.full_messages
            }, status: 501
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
                                  :country, :state, :city, :neighbourhood, :street, :number, :complement, :image)
  end

  def limit
    [
      params.fetch(:limit, 10).to_i,
      100
    ].min
  end
end
