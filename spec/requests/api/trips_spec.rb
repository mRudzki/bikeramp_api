require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe "Api::Trips", type: :request do
  describe "POST /api/trips" do
    context "when input is valid" do
      let(:trip_params) do
        {
          start_address: Faker::Address.full_address,
          destination_address: Faker::Address.full_address,
          price: 17.45,
          date: Date.today
        }
      end

      it "creates record" do
        aggregate_failures do
          expect { post api_trips_path, params: { trip: trip_params }, as: :json }.to change(Trip, :count).by(1)
          expect(response).to have_http_status(:ok)
        end
      end

      it "queues sidekiq worker" do
        expect { post api_trips_path, params: { trip: trip_params }, as: :json }.to change {
          DistanceCalculatorWorker.jobs.size
        }.by(1)
      end

      it "allows sidekiq to change record" do
        Sidekiq::Testing.inline! do
          post api_trips_path, params: { trip: trip_params }, as: :json
        end

        expect(Trip.last.distance).not_to be_nil
      end
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
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq(["Price must be greater than 0"])
      end
    end
  end
end
