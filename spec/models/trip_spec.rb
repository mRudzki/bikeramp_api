require 'rails_helper'
require 'faker'

RSpec.describe Trip, type: :model do
  describe "validations" do
    it 'allows valid record to be saved' do
      trip = build :trip

      expect(trip.save!).to eq(true)
    end
  end
end
