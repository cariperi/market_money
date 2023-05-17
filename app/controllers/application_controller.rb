class ApplicationController < ActionController::API
  def render_not_found_response(model, id)
    error_message = "Couldn't find #{model.name} with 'id'=#{id}"
    render json: ErrorSerializer.format_error(error_message), status: 404
  end

  def render_failed_validation_response(model)
    errors = model.errors.full_messages.join(", ")
    error_message = "Validation failed: #{errors}"
    render json: ErrorSerializer.format_error(error_message), status: 400
  end
end
