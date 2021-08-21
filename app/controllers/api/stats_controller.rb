class Api::StatsController < ApplicationController
  def weekly
    trips = Trip.where('date > ?', beginning_of_week)

    render json: { 'total_distance': trips.sum(:distance), 'total_price': trips.sum(:price) }
  end

  def monthly

  end

  private

  def beginning_of_week
    Date.today.beginning_of_week
  end

  def beginning_of_month
    Date.today.beginning_of_month
  end
end
