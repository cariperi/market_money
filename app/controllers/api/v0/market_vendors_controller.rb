class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market, only: [:index]

  def index
    render json: VendorSerializer.new(@market.vendors)
  end

  def create
    market_vendor = MarketVendor.create(market_vendor_params)
    if market_vendor.valid?
      render_success_message
    elsif ids_missing?
      render_missing_ids_message
    elsif market_vendor.errors[:market_id] == ["cannot create"]
      render_record_exists_response(market_vendor)
    else
      render_id_not_found_response(market_vendor)
    end
  end

  private
    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end

    def find_market
      @market = Market.find_by(id: params[:market_id])
      render_not_found_response(Market, params[:market_id]) if @market.nil?
    end

    def ids_missing?
      market_vendor_params[:market_id].nil? || market_vendor_params[:vendor_id].nil?
    end

    def render_missing_ids_message
      render json: { "message": "Market ID and Vendor ID must be provided" }, status: 400
    end

    def render_success_message
      render json: { "message": "Successfully added vendor to market" }, status: 201
    end

    def render_id_not_found_response(model)
      errors = model.errors.full_messages.join(", ")
      error_message = "Validation failed: #{errors}"
      render json: ErrorSerializer.format_error(error_message), status: 404
    end

    def render_record_exists_response(model)
      error_message = "Validation failed: Market vendor association between market with market_id=#{model.market_id} and vendor_id=#{model.vendor_id} already exists"
      render json: ErrorSerializer.format_error(error_message), status: 422
    end
end