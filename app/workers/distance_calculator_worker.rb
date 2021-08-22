class DistanceCalculatorWorker
  include Sidekiq::Worker
  require "http"

  def perform(trip_id)
    trip = Trip.find(trip_id)
    request_address = "http://www.mapquestapi.com/directions/v2/route"
    # details about API https://developer.mapquest.com/documentation/directions-api/
    params = {
      key: ENV.fetch("MAP_QUEST_KEY"),
      from: trip.start_address,
      to: trip.destination_address,
      unit: 'k' #k-kilometers, default unit is mile
    }
    response = HTTP.get(request_address, params: params)

    raise Exception.new "Wrong data or API key please review them" if response.status != 200

    trip.update(distance: response.parse['route']['distance'])
  end
end
