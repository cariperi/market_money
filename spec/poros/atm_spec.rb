require 'rails_helper'

RSpec.describe Atm do
  describe 'initialization' do
    it 'exists and has attributes' do
      attributes = {
        name: "ATM",
        address: "123 Main St.",
        lat: 1.2345,
        lon: -5.4321,
        distance: 0.12345
      }

      atm = Atm.new(attributes)

      expect(atm).to be_an(Atm)
      expect(atm.name).to eq("ATM")
      expect(atm.address).to eq("123 Main St.")
      expect(atm.lat).to eq(1.2345)
      expect(atm.lon).to eq(-5.4321)
      expect(atm.distance).to eq(0.12345)
    end
  end
end