class Api::TripsController < ApplicationController
  def create
    trip = Trip.new(trip_params)
    if trip.save
      DistanceCalculatorWorker.perform_async(trip.id)
      render json: trip
    else
      render json: { errors: trip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def trip_params
    params.require(:trip).permit(:price, :start_address, :destination_address, :date)
  end
end
