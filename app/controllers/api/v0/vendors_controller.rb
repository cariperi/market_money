class Api::V0::VendorsController < ApplicationController
  def show
    vendor = VendorsFacade.find_vendor(params[:id])
    if vendor.class == Vendor
      render json: VendorSerializer.new(vendor)
    else
      render json: ErrorSerializer.format_error(vendor), status: vendor.code
    end
  end
end