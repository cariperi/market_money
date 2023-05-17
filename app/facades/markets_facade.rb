class MarketsFacade
  def self.search_markets(name, city, state)
    Market.where("name ILIKE ? and city ILIKE ? and state ILIKE ?", "%#{name}%", "%#{city}%", "%#{state}%")
  end
end
