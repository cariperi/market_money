class ErrorSerializer
  def self.format_error(error)
    {
      errors: [
        {
          detail: error.detail
        }
      ]
    }
  end
end
