class ErrorSerializer
  def self.format_error(error)
    {
      errors: [
        {
          detail: error.message
        }
      ]
    }
  end
end
