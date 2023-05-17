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

        keys = [:name, :description, :contact_name, :contact_phone]
        keys.each do |key|
          expect(attributes).to have_key(key)
          expect(attributes[key]).to be_a(String)
        end

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
    it 'can create a new association between a market and a vendor with valid ids' do
      market = create(:market)
      vendor = create(:vendor)

      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:message)

      expect(data[:message]).to eq("Successfully added vendor to market")

      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendors = data[:data]
      expect(vendors).to be_an(Array)
      expect(vendors.count).to eq(1)

      new_vendor = vendors[0]
      expect(new_vendor[:id]).to eq(vendor.id.to_s)
    end

    it 'returns a custom error message if the market id is invalid' do
      vendor = create(:vendor)

      market_vendor_params = ({
        market_id: 5,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Validation failed: Market must exist")
    end

    it 'returns a custom error message if the vendor id is invalid' do
      market = create(:market)

      market_vendor_params = ({
        market_id: market.id,
        vendor_id: 5
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Validation failed: Vendor must exist")
    end

    it 'returns a custom error message if vendor id and / or market id are not passed in' do
      market_vendor_params = ({
        vendor_id: 5
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:message)

      expect(data[:message]).to eq("Market ID and Vendor ID must be provided")
    end

    it 'returns a custom error mesage if the association already exists' do
      market_1 = create(:market)
      vendor_1 = create(:vendor)
      MarketVendor.create!(market: market_1, vendor: vendor_1)

      market_vendor_params = ({
        market_id: market_1.id,
        vendor_id: vendor_1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Validation failed: Market vendor association between market with market_id=#{market_1.id} and vendor_id=#{vendor_1.id} already exists")
    end
  end

  describe 'Delete a Market Vendor' do
    it 'can destroy an association between a market and a vendor when ids are valid' do
      vendor = create(:vendor)
      market = create(:market)
      mv = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)

      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")

      expect{MarketVendor.find(mv.id)}.to raise_error(ActiveRecord::RecordNotFound)

      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      vendors = data[:data]
      expect(vendors).to be_an(Array)
      expect(vendors.count).to eq(0)
    end

    it 'returns an error message if no Market Vendor exists with the given ids' do
      market_vendor_params = ({
        market_id: 1,
        vendor_id: 2
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("No MarketVendor with market_id=1 AND vendor_id=2 exists")
    end
  end
end