class DayStatisticsCreator
  def initialize(day)
    @day = day
  end

  def call
    { day: date_formatted, total_distance: "#{day_distance} km", avg_ride: "#{avg_distance} km", avg_price: average_price_formatted }
  end

  private

  attr_accessor :day

  def date_formatted
    date.strftime("%B, #{date.day.ordinalize}")
  end

  def date
    @date ||= day.first
  end

  def day_distance
    @day_distance ||= day_data.sum(&:distance).to_d
  end

  def day_data
    @day_data ||= day.second
  end

  def avg_distance
    (day_distance / day_data.size).to_d.round(3)
  end

  def average_price_formatted
    ActiveSupport::NumberHelper.number_to_currency(avg_price, unit: "PLN", format: "%n %u")
  end

  def avg_price
    (day_data.sum(&:price) / day_data.size).to_d
  end
end
