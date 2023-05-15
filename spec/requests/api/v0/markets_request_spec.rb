require 'rails_helper'

describe 'Market Endpoints' do
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
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:type)
      expect(market[:type]).to be_a(String)
      expect(market[:type]).to eq('market')

      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      attributes = market[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:street)
      expect(attributes[:street]).to be_a(String)

      expect(attributes).to have_key(:city)
      expect(attributes[:city]).to be_a(String)

      expect(attributes).to have_key(:county)
      expect(attributes[:county]).to be_a(String)

      expect(attributes).to have_key(:state)
      expect(attributes[:state]).to be_a(String)

      expect(attributes).to have_key(:zip)
      expect(attributes[:zip]).to be_a(String)

      expect(attributes).to have_key(:lat)
      expect(attributes[:lat]).to be_a(String)

      expect(attributes).to have_key(:lon)
      expect(attributes[:lon]).to be_a(String)

      expect(attributes).to have_key(:vendor_count)
      expect(attributes[:vendor_count]).to be_an(Integer)
    end
  end
end
