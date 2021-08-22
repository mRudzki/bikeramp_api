class DistanceCalculatorWorker
  include Sidekiq::Worker
  require "http"

  def perform(trip_id)
    trip = Trip.find(trip_id)
    request_address = "http://www.mapquestapi.com/directions/v2/route"
    form = {
      key: ENV.fetch("MAP_QUEST_KEY"),
      from: trip.start_address,
      to: trip.destination_address,
      unit: 'k' # k-kilometers, default unit is mile
    }
    response = HTTP.get(request_address, params: form)

    raise(StandardError.new, "Wrong data or API key please review them") if response.status != 200

    raise(StandardError.new, "No route found") if response.parse['route']['distance'].nil?

    trip.update(distance: response.parse['route']['distance'])
  end
end
