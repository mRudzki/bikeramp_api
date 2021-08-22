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

    it 'does not allow the same address as start and destination point' do
      address = Faker::Address.full_address
      trip = build :trip, start_address: address, destination_address: address

      aggregate_failures do
        expect(trip.valid?).to eq(false)
        expect { trip.save! }.to raise_error("Validation failed: Destination address cannot be the same as start address")
      end
    end

    it 'does not allow empty start address' do
      trip = build :trip, start_address: nil

      aggregate_failures do
        expect(trip.valid?).to eq(false)
        expect { trip.save! }.to raise_error("Validation failed: Start address can't be blank")
      end
    end

    it 'does not allow empty start address' do
      trip = build :trip, destination_address: nil

      aggregate_failures do
        expect(trip.valid?).to eq(false)
        expect { trip.save! }.to raise_error("Validation failed: Destination address can't be blank")
      end
    end
  end
end
