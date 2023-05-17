class Api::V0::MarketsController < ApplicationController
  before_action :find_market, only: [:show]
  before_action :validate_params, only: [:search]

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(@market)
  end

  def search
    @markets = MarketsFacade.search_markets(params[:name], params[:city], params[:state])
    render json: MarketSerializer.new(@markets)
  end

  private

    def find_market
      @market = Market.find_by(id: params[:id])
      render_not_found_response(Market, params[:id]) if @market.nil?
    end

    def validate_params
      if only_city? || only_city_name?
        render_invalid_params_response
      end
    end

    def only_city?
      params[:city].present? && !params[:name].present? && !params[:state].present?
    end

    def only_city_name?
      params[:city].present? && params[:name] && !params[:state].present?
    end

    def render_invalid_params_response
      error_message = "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
      error = Error.new(error_message, 422)
      render json: ErrorSerializer.format_error(error), status: error.status_code
    end
end