class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: [:show, :update, :destroy]

  def show
    render json: VendorSerializer.new(@vendor)
  end

  def create
    vendor = Vendor.create(vendor_params)
    if vendor.valid?
      render json: VendorSerializer.new(vendor), status: 201
    else
      render_failed_validation_response(vendor)
    end
  end

  def update
    if @vendor.update(vendor_params)
      render json: VendorSerializer.new(@vendor)
    else
      render_failed_validation_response(@vendor)
    end
  end

  def destroy
    render json: @vendor.destroy, status: 204
  end

  private

    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end

    def find_vendor
      @vendor = Vendor.find_by(id: params[:id])
      render_not_found_response(Vendor, params[:id]) if @vendor.nil?
    end
end