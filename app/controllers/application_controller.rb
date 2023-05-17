class ApplicationController < ActionController::API
  def render_not_found_response(model, id)
    error_message = "Couldn't find #{model.name} with 'id'=#{id}"
    error = Error.new(error_message, 404)
    render json: ErrorSerializer.format_error(error), status: error.status_code
  end

  def render_failed_validation_response(model)
    errors = model.errors.full_messages.join(", ")
    error_message = "Validation failed: #{errors}"
    error = Error.new(error_message, 400)
    render json: ErrorSerializer.format_error(error), status: error.status_code
  end
end
