require 'rails_helper'

describe 'Market Endpoints' do
  describe 'Get All Markets' do
    it 'sends a list of all markets' do
      market_1 = create(:market)
      market_2 = create(:market)
      market_3 = create(:market)

      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      vendor_3 = create(:vendor)

      MarketVendor.create!(market: market_1, vendor: vendor_1)
      MarketVendor.create!(market: market_1, vendor: vendor_2)
      MarketVendor.create!(market: market_2, vendor: vendor_3)

      get '/api/v0/markets'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      markets = data[:data]
      expect(markets).to be_an(Array)
      expect(markets.count).to eq(3)

      markets.each do |market|
        expect(market).to be_a(Hash)

        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to be_a(String)
        expect(market[:type]).to eq('market')

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)

        attributes = market[:attributes]

        keys = [:name, :street, :city, :county, :state, :zip, :lat, :lon]
        keys.each do |key|
          expect(attributes).to have_key(key)
          expect(attributes[key]).to be_a(String)
        end

        expect(attributes).to have_key(:vendor_count)
        expect(attributes[:vendor_count]).to be_an(Integer)
      end
    end
  end

  describe 'Get One Market' do
    it 'can get one market by its id' do
      market_1 = create(:market)

      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)

      MarketVendor.create!(market: market_1, vendor: vendor_1)
      MarketVendor.create!(market: market_1, vendor: vendor_2)

      get "/api/v0/markets/#{market_1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      market = data[:data]
      expect(market).to be_a(Hash)

      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)
      expect(market[:id]).to eq(market_1.id.to_s)

      expect(market).to have_key(:type)
      expect(market[:type]).to be_a(String)
      expect(market[:type]).to eq('market')

      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      attributes = market[:attributes]
      keys = [:name, :street, :city, :county, :state, :zip, :lat, :lon]
      keys.each do |key|
        expect(attributes).to have_key(key)
        expect(attributes[key]).to be_a(String)
      end

      expect(attributes[:name]).to eq(market_1.name)
      expect(attributes[:street]).to eq(market_1.street)
      expect(attributes[:city]).to eq(market_1.city)
      expect(attributes[:county]).to eq(market_1.county)
      expect(attributes[:state]).to eq(market_1.state)
      expect(attributes[:zip]).to eq(market_1.zip)
      expect(attributes[:lat]).to eq(market_1.lat)
      expect(attributes[:lon]).to eq(market_1.lon)

      expect(attributes).to have_key(:vendor_count)
      expect(attributes[:vendor_count]).to be_an(Integer)
      expect(attributes[:vendor_count]).to eq(market_1.vendors.count)
    end

    it 'returns an error if an invalid market id is passed in' do

      get "/api/v0/markets/5"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Couldn't find Market with 'id'=5")
    end
  end
end
