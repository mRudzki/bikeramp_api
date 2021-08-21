require 'rails_helper'

RSpec.describe "Api::Stats", type: :request do
  describe "GET /weekly" do
    before do
      # First price should not be counted in stats because it is created before start of the week
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
end
