class V1::HotelsController < ApplicationController
  def hotels
    hotels = Hotel.includes(image_attachment: :blob).limit(limit).offset(params[:offset])
    hotels.map do |hotel|
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
  end

  def index
    JsonWebToken.decode request.headers['token']
    render json: {
      data: hotels
    }
  rescue JWT::DecodeError
    render json: {
      error: 'Invalid Token'
    }, status: 500
  end

  def create_feature(parameters)
    Feature.create!(room: parameters[:room], pool: parameters[:pool], bar: parameters[:bar],
                    air_conditioning: parameters[:air_conditioning],
                    tv: parameters[:tv], gym: parameters[:gym])
  end

  def create_address(parameters)
    Address.create!(country: parameters[:country], state: parameters[:state], city: parameters[:city],
                    neighbourhood: parameters[:neighbourhood], street: parameters[:street],
                    number: parameters[:number], complement: parameters[:complement])
  end

  def create
    username_from_token = JsonWebToken.decode request.headers['token']
    user = User.where(name: username_from_token).first
    parameters = hotels_params
    ActiveRecord::Base.transaction do
      feature = create_feature parameters
      address = create_address parameters
      Hotel.create(name: parameters[:name], description: parameters[:description], feature_id: feature.id,
                   address_id: address.id, user_id: user.id, image: parameters[:image])
      render json: {
        message: 'Hotel created successfully'
      }, status: 200
    end
  rescue JWT::DecodeError
    render json: {
      error: 'Invalid Token'
    }, status: 500
  rescue ActiveRecord::Rollback
    render json: {
      error: 'Unable to create reservation. ActiveRecord::Rollback '
    }, status: 501
  rescue ActiveRecord::StatementInvalid
    render json: {
      error: 'Unable to create reservation. ActiveRecord::StatementInvalid'
    }, status: 501
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: 'Error saving user to database',
      error_list: e.record.errors.full_messages
    }, status: 501
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
