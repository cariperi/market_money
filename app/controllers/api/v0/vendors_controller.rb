class Api::V0::VendorsController < ApplicationController
  def show
    vendor = VendorsFacade.find_vendor(params[:id])
    if vendor.class == Vendor
      render json: VendorSerializer.new(vendor)
    else
      render json: ErrorSerializer.format_error(vendor), status: vendor.code
    end
  end

  def create
    vendor = VendorsFacade.create_vendor(vendor_params)
    if vendor.class == Vendor
      render json: VendorSerializer.new(vendor), status: 201
    else
      render json: ErrorSerializer.format_error(vendor), status: vendor.code
    end
  end

  private

    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end