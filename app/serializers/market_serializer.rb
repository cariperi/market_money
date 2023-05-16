class MarketSerializer
  def self.format_markets(markets)
    {
      "data": markets.map do |market|
          {
            "id": market.id.to_s,
            "type": market.class.to_s.downcase,
            "attributes": {
              "name": market.name,
              "street": market.street,
              "city": market.city,
              "county": market.county,
              "state": market.state,
              "zip": market.zip,
              "lat": market.lat,
              "lon": market.lon,
              "vendor_count": market.vendor_count
            }
          }
      end
    }
  end

  def self.format_market(market)
    {
      "data": {
            "id": market.id.to_s,
            "type": market.class.to_s.downcase,
            "attributes": {
              "name": market.name,
              "street": market.street,
              "city": market.city,
              "county": market.county,
              "state": market.state,
              "zip": market.zip,
              "lat": market.lat,
              "lon": market.lon,
              "vendor_count": market.vendor_count
            }
          }
    }
  end
end