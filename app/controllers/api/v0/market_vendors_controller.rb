class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market, only: [:index]
  before_action :find_market_vendor, only: [:destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :failed_validation_response

  def index
    render json: VendorSerializer.new(@market.vendors)
  end

  def create
    MarketVendor.create!(market_vendor_params)
    render json: { "message": "Successfully added vendor to market" }, status: 201
  end

  def destroy
    render json: @market_vendor.destroy, status: 204
  end

  private
    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end

    def find_market
      @market = Market.find(params[:market_id])
    end

    def find_market_vendor
      @market_vendor = MarketVendor.find_by(market_id: market_vendor_params[:market_id], vendor_id: market_vendor_params[:vendor_id])
      if @market_vendor.nil?
        message = "No MarketVendor with market_id=#{market_vendor_params[:market_id]} AND vendor_id=#{market_vendor_params[:vendor_id]} exists"
        raise ActiveRecord::RecordNotFound, message
      end
    end
end