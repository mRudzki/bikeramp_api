require 'rails_helper'

RSpec.describe "Api::Stats", type: :request do
  describe "GET /weekly" do
    before do
      # First price and distance should not be counted in stats because it is created before start of the week
      create :trip, date: Date.today.beginning_of_week - 1.day
      create :trip, distance: 2.123, price: 12.34
      create :trip, distance: 5.986, price: 83.68
    end

    it "returns sum of all trip distances of current week" do
      get api_stats_weekly_path

      expect(JSON.parse(response.body)['total_distance']).to eq('8.109')
      expect(JSON.parse(response.body)['total_price']).to eq('96.02')
    end
  end

  fdescribe "GET /monthly" do
    let(:spec_date) { Date.new(2021, 8, 22) }
    before do
      Timecop.freeze(spec_date)
      # First trip should not be counted in stats because it is created before start of the week
      create :trip, date: Date.today.beginning_of_month - 1.day
      # First day group
      create :trip, distance: 3, price: 12.34, date: spec_date - 2.days
      create :trip, distance: 5, price: 83.68, date: spec_date - 2.days
      # Another day group
      create :trip, distance: 2.123, price: 12.34, date: spec_date.yesterday
      create :trip, distance: 5.986, price: 83.68, date: spec_date.yesterday
      # Add trip with not yet calculated distance data
      create :trip, distance: nil, price: 12.34, date: spec_date
    end

    after { Timecop.return }

    it "returns list of all days statistics of current month" do
      get api_stats_monthly_path

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(3)
    end

    it "contains correct data for each day" do
      get api_stats_monthly_path

      aggregate_failures do
        # First day part
        expect(JSON.parse(response.body).first["day"]).to eq('August, 20th')
        expect(JSON.parse(response.body).first["total_distance"]).to eq('8.0 km')
        expect(JSON.parse(response.body).first["avg_ride"]).to eq('4.0 km')
        expect(JSON.parse(response.body).first["avg_price"]).to eq('48.01 PLN')

        # Second day part
        expect(JSON.parse(response.body).second["day"]).to eq('August, 21st')
        expect(JSON.parse(response.body).second["total_distance"]).to eq('8.109 km')
        expect(JSON.parse(response.body).second["avg_ride"]).to eq('4.055 km')
        expect(JSON.parse(response.body).second["avg_price"]).to eq('48.01 PLN')

        # Last day part
        binding.pry
        expect(JSON.parse(response.body).last["day"]).to eq('August, 22nd')
        expect(JSON.parse(response.body).last["total_distance"]).to eq('0.0 km')
        expect(JSON.parse(response.body).last["avg_ride"]).to eq('0.0 km')
        expect(JSON.parse(response.body).last["avg_price"]).to eq('12.34 PLN')
      end
    end
  end
end
