class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  # validate :record_must_be_unique, on: :create
  validates :market_id, uniqueness: {scope: :vendor_id, message: "cannot create"}, on: :create
  # def record_must_be_unique
  #   mid = market_id.to_i
  #   vid = vendor_id.to_i

  #   if MarketVendor.where(["market_id = ? and vendor_id = ?", mid, vid]).count > 0
  #     errors.add(:market_vendor, "cannot create")
  #   end
  # end
end
