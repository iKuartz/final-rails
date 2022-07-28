class V1::ReservationController < ApplicationController
  def index
    render json: {
      status: 'Under Construction'
    }
  end

  def rooms_available_on_date(reserved_rooms, rooms_free)
    rooms_free.to_i >= reserved_rooms.to_i
  end

  def check_availaibility(start_date, end_date, available_on_date_for_hotel_list, reserved_rooms, hotel)
    available_dates_list = []
    (start_date..end_date).each do |date|
      date_list = available_on_date_for_hotel_list.select { |available| available.date == date }
      puts date_list
      if date_list.length.zero?
        available_on_date_for_hotel = AvailableOnDate.new hotel_id: hotel.id, rooms_occopied: 0, date:, available: true,
                                                          rooms_free: hotel.feature.room
        date_list << available_on_date_for_hotel
      end
      unless rooms_available_on_date(reserved_rooms, date_list[0].rooms_free)
        raise StandardError, "Room not available on #{date_list[0].date}."
      end

      available_dates_list << date_list[0]
    end
    available_dates_list
  end

  def update_rooms_availability(available_dates_list, reserved_rooms)
    ActiveRecord::Base.transaction do
      available_dates_list.each do |available_date|
        available_date.rooms_occopied += reserved_rooms.to_i
        available_date.rooms_free -= reserved_rooms.to_i
        available_date.available = available_date.rooms_free.positive?
        available_date.save
      end
    end
  end

  def process_rooms_availability(hotel_id, start_date, end_date, reserved_rooms)
    available_on_date_for_hotel_list = AvailableOnDate.where(hotel_id:, date: start_date..end_date)
    hotel = Hotel.find hotel_id
    available_dates_list = []
    begin
      available_dates_list = check_availaibility start_date, end_date, available_on_date_for_hotel_list, reserved_rooms,
                                                 hotel
    rescue StandardError => e
      raise StandardError, e.message
    end

    begin
      update_rooms_availability available_dates_list, reserved_rooms
    rescue ActiveRecord::Rollback
      raise StandardError, 'Unable to create reservation. ActiveRecord::Rollback [1x602]'
    rescue ActiveRecord::StatementInvalid
      raise StandardError, 'Unable to create reservation. ActiveRecord::StatementInvalid [1x603]'
    end
  end

  def create
    token = request.headers['token']
    secret = Rails.application.secret_key_base.to_s

    begin
      decoded_token = JWT.decode token, secret, true, { algorithm: 'HS256' }
      decoded_username = decoded_token[0]['name']
      user = User.where(name: decoded_username).first
      parameters = reservation_params

      start_date = Date.parse(parameters[:start_date])
      end_date = Date.parse(parameters[:end_date])

      if start_date.past?
        render json: {
          error: 'Unable to create reservation[1x604]',
          error_list: ['Can not have a date from past']
        }
        return
      end

      if start_date > end_date
        render json: {
          error: 'Unable to create reservation[1x605]',
          error_list: ['Start date can not be after the end date.']
        }
        return
      end

      if parameters[:reserved_rooms].to_i < 1
        render json: {
          error: 'Unable to create reservation[1x606]',
          error_list: ['You should reserve at least one room.']
        }
        return
      end

      reservation = Reservation.create user_id: user.id, hotel_id: parameters[:hotel_id],
                                       date_from: parameters[:start_date], date_to: parameters[:end_date],
                                       reserved_rooms: parameters[:reserved_rooms]
      if reservation.new_record?
        render json: {
          error: 'Unable to create reservation[1x601]',
          error_list: reservation.errors.full_messages
        }, status: 500
      else
        begin
          process_rooms_availability parameters[:hotel_id], parameters[:start_date], parameters[:end_date],
                                     parameters[:reserved_rooms]
        rescue StandardError => e
          reservation.destroy
          render json: {
            error: 'Unable to create reservation. Internal Server Error.',
            error_list: [e.message]
          }, status: 500
          return
        end
        render json: {
          message: "Hotel reserved from #{reservation.date_from} to #{reservation.date_to}."
        }, status: 200
      end
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
