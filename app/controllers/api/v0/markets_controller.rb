class Api::V0::MarketsController < ApplicationController
  before_action :find_market, only: [:show]

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(@market)
  end

  private

    def find_market
      @market = Market.find_by(id: params[:id])
      render_not_found_response(Market, params[:id]) if @market.nil?
    end
end