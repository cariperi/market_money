class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.format_markets(Market.all)
  end

  def show
    market = MarketsFacade.find_market(params[:id])
    if market.class == Market
      render json: MarketSerializer.format_market(market)
    else
      render json: ErrorSerializer.format_error(market), status: 404
    end
  end
end