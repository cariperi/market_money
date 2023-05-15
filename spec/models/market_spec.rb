require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'associations' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    describe '#vendor_count' do
      it 'should return the number of vendors associated with a given market' do
        market_1 = create(:market)
        market_2 = create(:market)
        market_3 = create(:market)

        vendor_1 = create(:vendor)
        vendor_2 = create(:vendor)
        vendor_3 = create(:vendor)

        MarketVendor.create!(market: market_1, vendor: vendor_1)
        MarketVendor.create!(market: market_1, vendor: vendor_2)
        MarketVendor.create!(market: market_2, vendor: vendor_3)

        expect(market_1.vendor_count).to eq(2)
        expect(market_2.vendor_count).to eq(1)
        expect(market_3.vendor_count).to eq(0)
      end
    end
  end
end
