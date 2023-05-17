class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market, only: [:index]

  def index
    render json: VendorSerializer.new(@market.vendors)
  end

  private

    def find_market
      @market = Market.find_by(id: params[:market_id])
      render_not_found_response(Market, params[:market_id]) if @market.nil?
    end
end