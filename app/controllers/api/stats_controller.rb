class Api::StatsController < ApplicationController
  def weekly
    trips = Trip.where('date > ?', beginning_of_week)

    render json: { 'total_distance': trips.sum(:distance), 'total_price': trips.sum(:price) }
  end

  def monthly
    trips = Trip.where('date > ?', beginning_of_month).order(:date).group_by(&:date)
    groups = trips.map do|group|
      day = group.first
      day_formatted = day.strftime("%B, #{day.day.ordinalize}")
      group_records = group.second
      total_distance = group_records.sum(&:distance)
      avg_distance = total_distance / group_records.size
      avg_price = group_records.sum(&:price) / group_records.size
      { day: day_formatted, total_distance: total_distance, avg_ride: avg_distance, avg_price: avg_price }
    end

    render json: groups
  end

  private

  def beginning_of_week
    Date.today.beginning_of_week
  end

  def beginning_of_month
    Date.today.beginning_of_month
  end
end
