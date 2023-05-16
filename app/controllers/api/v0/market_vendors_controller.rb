class Api::V0::MarketVendorsController < ApplicationController
  def index
    market = MarketsFacade.find_market(params[:market_id])
    if market.class == Market
      render json: VendorSerializer.new(market.vendors)
    else
      render json: ErrorSerializer.format_error(market), status: market.code
    end
  end
end