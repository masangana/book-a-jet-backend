class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[destroy]
  def index
    @reservations = current_user.reservations.includes(:user, :jet).as_json(
      only: %i[starting_day finish_day city id jet_id],
      include: {
        jet: {
          only: %i[name description size category image price_per_day finance_fee id]
        },
        user: {
          only: %i[id name username]
        }

      }
    )
    render json: @reservations
  end

  def show
    @reservation = Reservation.find_by(id: params[:id])
    if @reservation
      render json: @reservation
    else
      render json: { error: 'No reservation found' }
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user = current_user
    if @reservation.save
      render json: { message: 'Reservation created successfully', reservation: @reservation }
    else
      render json: { error: 'Unable to create reservation' }
    end
  end

  def destroy
    if @reservation.present?
      if @reservation.destroy
        render json: { message: 'Reservation deleted successfully' }, status: :no_content
      else
        render json: { error: 'Unable to delete reservation' }, status: :unprocessable_entity
      end
    else
      render status: :not_found
    end
  end

  def update
    @reservation = Reservation.find_by(id: params[:id])
    if @reservation
      @reservation.update(reservation_params)
      render json: { message: 'Reservation updated successfully' }
    else
      render json: { error: 'Unable to update reservation' }
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:jet_id, :starting_day, :finish_day, :city)
  end
end
