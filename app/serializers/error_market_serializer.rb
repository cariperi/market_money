class ErrorMarketSerializer
  def self.format_error_market(error_market)
    {
      errors: [
        {
          detail: error_market.detail
        }
      ]
    }
  end
end
