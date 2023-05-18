class Api::V0::AtmsController < ApplicationController
  before_action :find_market, only: [:index]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    @atms = AtmsFacade.new(@market).atms
    render json: AtmSerializer.new(@atms)
  end

  private
    def find_market
      @market = Market.find(params[:market_id])
    end
end
