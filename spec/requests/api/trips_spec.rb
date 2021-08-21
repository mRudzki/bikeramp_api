require 'rails_helper'

RSpec.describe "Api::Trips", type: :request do
  describe "POST /api/trips" do
    it "creates record for valid input" do
      trip_params = {
          start_address: Faker::Address.full_address,
          destination_address: Faker::Address.full_address,
          price: 17.45,
          date: Date.today
        }

      expect { post api_trips_path, params: { trip: trip_params }, as: :json }.to change(Trip, :count).by(1)
      expect(response.status).to eq(200)
    end

    it "returns errors on invalid record" do

        trip_params = {
          start_address: Faker::Address.full_address,
          destination_address: Faker::Address.full_address,
          price: -20,
          date: Date.today
        }
      aggregate_failures do
        expect { post api_trips_path, params: { trip: trip_params }, as: :json }.not_to change(Trip, :count)
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['errors']).to eq(["Price must be greater than 0"])
      end
    end
  end
end
