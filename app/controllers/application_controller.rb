class ApplicationController < ActionController::API
  def not_found_response(error)
    error_object = Error.new(error.message, 404)
    render json: ErrorSerializer.format_error(error_object), status: error_object.status_code
  end

  def failed_validation_response(error)
    error_object = Error.new(error.message, set_error_code(error.record))
    render json: ErrorSerializer.format_error(error_object), status: error_object.status_code
  end

  private
    def set_error_code(record)
      if record.errors.any? {|e| e.type == :already_exists}
        422
      elsif record.class == MarketVendor && (record.market_id.nil? || record.vendor_id.nil?)
        400
      elsif record.class == Vendor
        400
      else
        404
      end
    end
end
