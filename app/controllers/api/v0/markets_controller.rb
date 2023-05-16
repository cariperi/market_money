class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    market = MarketsFacade.find_market(params[:id])
    if market.class == Market
      render json: MarketSerializer.new(market)
    else
      render json: ErrorSerializer.format_error(market), status: 404
    end
  end
end