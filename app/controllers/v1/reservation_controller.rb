# rubocop:disable Metrics/ClassLength
class V1::ReservationController < ApplicationController
  def index
    decoded_username = JsonWebToken.decode request.headers['token']
    user = User.where(name: decoded_username).first
    reservations = Reservation.where(user_id: user.id).as_json(except: %i[created_at updated_at user_id])
    render json: {
      reservations:
    }, status: 200
  rescue JWT::DecodeError
    render json: {
      error: 'Invalid Token'
    }, status: 500
  end

  def rooms_available_on_date(reserved_rooms, rooms_free)
    rooms_free.to_i >= reserved_rooms.to_i
  end

  def check_availaibility(start_date, end_date, available_on_date_for_hotel_list, reserved_rooms, hotel)
    available_dates_list = []
    (start_date..end_date).each do |date|
      date_list = available_on_date_for_hotel_list.select { |available| available.date == date }
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
    available_dates_list.each do |available_date|
      available_date.rooms_occopied += reserved_rooms.to_i
      available_date.rooms_free -= reserved_rooms.to_i
      available_date.available = available_date.rooms_free.positive?
      available_date.save
    end
  end

  def process_rooms_availability(hotel_id, start_date, end_date, reserved_rooms)
    available_on_date_for_hotel_list = AvailableOnDate.where(hotel_id:, date: start_date..end_date)
    hotel = Hotel.find hotel_id
    available_dates_list = check_availaibility start_date, end_date, available_on_date_for_hotel_list, reserved_rooms,
                                               hotel

    update_rooms_availability available_dates_list, reserved_rooms
  end

  def check_validations(start_date, end_date, reserved_rooms)
    if start_date.past?
      return {
        error: 'Unable to create reservation[1x604]',
        error_list: ['Can not have a date from past']
      }
    end

    if start_date > end_date
      return {
        error: 'Unable to create reservation[1x605]',
        error_list: ['Start date can not be after the end date.']
      }
    end

    if reserved_rooms.to_i < 1
      return {
        error: 'Unable to create reservation[1x606]',
        error_list: ['You should reserve at least one room.']
      }
    end
    nil
  end

  def create_reservation(parameters, user)
    Reservation.create! user_id: user.id, hotel_id: parameters[:hotel_id],
                        date_from: parameters[:start_date], date_to: parameters[:end_date],
                        reserved_rooms: parameters[:reserved_rooms]
  end

  def create
    decoded_username = JsonWebToken.decode request.headers['token']
    user = User.where(name: decoded_username).first
    parameters = reservation_params
    start_date = Date.parse(parameters[:start_date])
    end_date = Date.parse(parameters[:end_date])

    validation_check = check_validations(start_date, end_date, parameters[:reserved_rooms])
    unless validation_check.nil?
      render json: validation_check, status: 501
      return
    end
    ActiveRecord::Base.transaction do
      reservation = create_reservation parameters, user
      process_rooms_availability parameters[:hotel_id], parameters[:start_date], parameters[:end_date],
                                 parameters[:reserved_rooms]
      render json: {
        message: "Hotel reserved from #{reservation.date_from} to #{reservation.date_to}."
      }, status: 200
    end
  rescue JWT::DecodeError
    render json: {
      error: 'Invalid Token'
    }, status: 500
  rescue ActiveRecord::Rollback
    render json: {
      message: 'Unable to create reservation. Internal Server Error.',
      error_list: 'Unable to create reservation. ActiveRecord::Rollback [1x602]'
    }, status: 501
  rescue ActiveRecord::StatementInvalid
    render json: {
      message: 'Unable to create reservation. Internal Server Error.',
      error_list: 'Unable to create reservation. ActiveRecord::StatementInvalid [1x603]'
    }, status: 501
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: 'Error saving user to database',
      error_list: e.record.errors.full_messages
    }, status: 501
  end

  def update_rooms_destruction(available_dates_list, reserved_rooms)
    available_dates_list.each do |available_date|
      available_date.rooms_occopied -= reserved_rooms.to_i
      available_date.rooms_free += reserved_rooms.to_i
      available_date.available = available_date.rooms_free.positive?
      available_date.save
    end
  end

  def destroy
    decoded_username = JsonWebToken.decode request.headers['token']
    user = User.where(name: decoded_username).first
    reservation_id = params[:id]
    target_reservation = Reservation.find(reservation_id)
    if user.id == target_reservation.user_id
      available_on_date_for_hotel_list = AvailableOnDate.where(
        hotel_id: target_reservation.hotel_id,
        date: target_reservation.date_from..target_reservation.date_to
      )

      ActiveRecord::Base.transaction do
        update_rooms_destruction(available_on_date_for_hotel_list, target_reservation.reserved_rooms)

        target_reservation.destroy
        if target_reservation.destroyed?
          render json: {
            message: 'Reservation successfully destroyed'
          }, status: 200
        else
          render json: {
            error: 'Unable to delete reservation'
          }, status: 501
        end
      end
    else
      render json: {
        error: 'User not authorized'
      }, status: 501
    end
  rescue JWT::DecodeError
    render json: {
      error: 'Invalid Token'
    }, status: 500
  rescue ActiveRecord::Rollback
    render json: {
      error: 'Unable to create reservation. ActiveRecord::Rollback [1x602]'
    }, status: 501
  rescue ActiveRecord::StatementInvalid
    render json: {
      error: 'Unable to create reservation. ActiveRecord::StatementInvalid [1x603]'
    }, status: 501
  end

  private

  def reservation_params
    params.require(:reservation).permit(:reserved_rooms, :hotel_id, :start_date, :end_date)
  end
end
# rubocop:enable Metrics/ClassLength
