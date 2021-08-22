require 'rails_helper'

RSpec.describe DayStatisticsCreator do
  describe "#call" do
    let(:day) do
      trip1 = create :trip, distance: 2.048, price: 32.64, date: Date.today
      trip2 = create :trip, distance: 1.024, price: 8.16, date: Date.today
      [
        Date.today,
        [
          trip1,
          trip2
        ]
      ]
    end

    it "perform all calculations correctly" do
      aggregate_failures do
        expect(described_class.new(day).call[:total_distance]).to eq('3.072 km')
        expect(described_class.new(day).call[:avg_ride]).to eq('1.536 km')
        expect(described_class.new(day).call[:avg_price]).to eq('20.40 PLN')
      end
    end

    context "when one of daily distances is nil" do
      let(:day) do
        trip_with_nil_distance = create :trip, distance: nil, date: Date.today
        trip = create :trip, distance: 2.048, date: Date.today
        [
          Date.today,
          [
            trip_with_nil_distance,
            trip
          ]
        ]
      end

      it "perform distance calculations correctly" do
        expect(described_class.new(day).call[:total_distance]).to eq('2.048 km')
      end
    end
  end
end
