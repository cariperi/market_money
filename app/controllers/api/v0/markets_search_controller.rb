class Api::V0::MarketsSearchController < ApplicationController
  before_action :validate_params, only: [:index]

  def index
    @markets = MarketsFacade.search_markets(params[:name], params[:city], params[:state])
    render json: MarketSerializer.new(@markets)
  end

  private

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