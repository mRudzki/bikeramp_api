require 'rails_helper'
require 'faker'

RSpec.describe Trip, type: :model do
  describe "validations" do
    it 'allows valid record to be saved' do
      trip = build :trip

      expect(trip.save!).to eq(true)
    end

    it 'does not allow negative price value' do
      trip = build :trip, price: -10.25

      aggregate_failures do
        expect(trip.valid?).to eq(false)
        expect { trip.save! }.to raise_error("Validation failed: Price must be greater than 0")
      end
    end
  end
end
