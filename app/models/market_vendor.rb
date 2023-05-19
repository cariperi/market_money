class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validate :record_must_be_unique, on: :create

  def record_must_be_unique
    mid = market_id.to_i
    vid = vendor_id.to_i

    if MarketVendor.where(["market_id = ? and vendor_id = ?", mid, vid]).exists?
      errors.add(:base, :already_exists, message: "Market vendor association between market with market_id=#{mid} and vendor_id=#{vid} already exists")
    end
  end
end
