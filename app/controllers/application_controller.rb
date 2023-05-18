class ApplicationController < ActionController::API
  def not_found_response(error)
    error_object = Error.new(error.message, 404)
    render json: ErrorSerializer.format_error(error_object), status: error_object.status_code
  end

  def render_failed_validation_response(model)
    errors = model.errors.full_messages.join(", ")
    error_message = "Validation failed: #{errors}"
    error = Error.new(error_message, 400)
    render json: ErrorSerializer.format_error(error), status: error.status_code
  end
end
