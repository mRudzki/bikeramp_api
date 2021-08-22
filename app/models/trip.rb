class Trip < ApplicationRecord
  validates :price, numericality: { greater_than: 0 }
  validate :addresses_validation
  validates :start_address, :destination_address, presence: true

  private

  def addresses_validation
    errors.add(:destination_address, "cannot be the same as start address") if start_address == destination_address
  end
end
