require 'rails_helper'

RSpec.describe 'ATM Finder Endpoint' do
  describe 'Get Cash Dispensers Near a Market' do
    it 'returns atms near the location of a given market' do
      market = create(:market, lat: 35.07904, lon: -106.60068)

      get "/api/v0/markets/#{market.id}/nearest_atms"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)

      atms = data[:data]
      expect(atms).to be_an(Array)

      atms.each do |atm|
        expect(atm).to be_a(Hash)

        expect(atm).to have_key(:id)
        expect(atm[:id]).to eq(nil)

        expect(atm).to have_key(:type)
        expect(atm[:type]).to be_a(String)
        expect(atm[:type]).to eq('atm')

        expect(atm).to have_key(:attributes)
        expect(atm[:attributes]).to be_a(Hash)

        attributes = atm[:attributes]

        string_keys = [:name, :address]
        string_keys.each do |key|
          expect(attributes).to have_key(key)
          expect(attributes[key]).to be_a(String)
        end

        float_keys = [:lat, :lon, :distance]
        float_keys.each do |key|
          expect(attributes).to have_key(key)
          expect(attributes[key]).to be_a(Float)
        end
      end
    end

    it 'returns an error if invalid market id is passed in' do
      get "/api/v0/markets/5/nearest_atms"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:errors)

      error = data[:errors][0][:detail]
      expect(error).to eq("Couldn't find Market with 'id'=5")
    end
  end
end
