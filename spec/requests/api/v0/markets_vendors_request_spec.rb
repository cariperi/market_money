require 'rails_helper'

describe 'Market Vendor Endpoints' do
  describe 'Get All Vendors for a Market' do
    it 'sends a list of vendors for a given market' do
      market_1 = create(:market)

      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      vendor_3 = create(:vendor)

      MarketVendor.create!(market: market_1, vendor: vendor_1)
      MarketVendor.create!(market: market_1, vendor: vendor_2)
      MarketVendor.create!(market: market_1, vendor: vendor_3)

      get "/api/v0/markets/#{market_1.id}/vendors"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendors = data[:data]
      expect(vendors).to be_an(Array)
      expect(vendors.count).to eq(3)

      vendors.each do |vendor|
        expect(vendor).to be_a(Hash)

        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to be_a(String)
        expect(vendor[:type]).to eq('vendor')

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a(Hash)

        attributes = vendor[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)

        expect(attributes).to have_key(:contact_name)
        expect(attributes[:contact_name]).to be_a(String)

        expect(attributes).to have_key(:contact_phone)
        expect(attributes[:contact_phone]).to be_a(String)

        expect(attributes).to have_key(:credit_accepted)
        expect(attributes[:credit_accepted]).to be_in([true, false])
      end
    end

    it 'returns an error if an invalid market id is passed in' do

      get "/api/v0/markets/5/vendors"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Couldn't find Market with 'id'=5")
    end
  end

  describe 'Create a Market Vendor' do
    xit 'can create a new association between a market and a vendor with valid ids' do
      market = create(:market)
      vendor = create(:vendor)

      params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(params: params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:message)

      expect(data[:message]).to eq("Successfully added vendor to market")
    end
  end
end