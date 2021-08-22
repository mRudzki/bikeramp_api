class DayStatisticsCreator
  def initialize(day)
    @day = day
  end

  def call
    { day: date_formatted, total_distance: "#{day_distance} km", avg_ride: avg_distance, avg_price: avg_price }
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
    @day_distance ||= day_data.sum(&:distance)
  end

  def day_data
    @day_data ||= day.second
  end

  def avg_distance
    (day_distance / day_data.size).round(3)
  end

  def avg_price
    (day_data.sum(&:price) / day_data.size).round(2)
  end
end
