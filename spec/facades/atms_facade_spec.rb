require 'rails_helper'

RSpec.describe AtmsFacade do
  describe 'ATMs Facade' do
    describe '#initialize' do
      it 'exists with a market object as an attribute' do
        market = create(:market)
        facade = AtmsFacade.new(market)

        expect(facade).to be_a(AtmsFacade)
        expect(facade.market).to be(market)
      end
    end
  end
end
