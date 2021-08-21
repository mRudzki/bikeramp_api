require 'rails_helper'
RSpec.describe DistanceCalculatorWorker, type: :worker do
  describe "#perform" do
    it "calls map quest api and updates trip distance" do
      trip = create :trip, start_address: "Plac Europejski 2, Warszawa, Polska", destination_address: "Rynek 4, Tarnowskie Góry, Polska"
      expect { described_class.new.perform(trip) }.to change{ trip.reload.distance }.to(278.627)
    end
  end
end
