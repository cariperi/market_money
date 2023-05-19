class Api::V0::AtmsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    atms = AtmsFacade.new(Market.find(params[:market_id])).atms
    render json: AtmSerializer.new(atms)
  end
end
