class ErrorSerializer
  def self.format_error(error_message)
    {
      errors: [
        {
          detail: error_message
        }
      ]
    }
  end
end
