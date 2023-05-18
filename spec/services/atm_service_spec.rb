require 'rails_helper'

RSpec.describe AtmService do
  context "instance methods" do
    context "find_atms(lat, lon)" do
      it 'returns ATM data' do
        VCR.use_cassette("market_with_known_lat_lon") do

          search = AtmService.new.find_atms(35.07904, -106.60068)

          expect(search).to be_a(Hash)
          expect(search[:results]).to be_an(Array)

          atm_data = search[:results].first

          expect(atm_data).to have_key(:poi)
          expect(atm_data[:poi][:name]).to be_a(String)

          expect(atm_data).to have_key(:address)
          expect(atm_data[:address][:freeformAddress]).to be_a(String)

          expect(atm_data).to have_key(:position)
          expect(atm_data[:position][:lat]).to be_a(Float)
          expect(atm_data[:position][:lon]).to be_a(Float)

          expect(atm_data).to have_key(:dist)
          expect(atm_data[:dist]).to be_a(Float)
        end
      end
    end
  end
end
