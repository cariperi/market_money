class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :failed_validation_response

  def show
    render json: VendorSerializer.new(@vendor)
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: 201
  end

  def update
    @vendor.update!(vendor_params)
    render json: VendorSerializer.new(@vendor)
  end

  def destroy
    render json: @vendor.destroy, status: 204
  end

  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end

    def find_vendor
      @vendor = Vendor.find(params[:id])
    end
end