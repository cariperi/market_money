class MarketsFacade
  def self.find_market(id)
    if Market.exists?(id: id)
      Market.find(id)
    else
      ErrorMarket.new("Couldn't find Market with 'id'=#{id}", "NOT FOUND", 404)
    end
  end
end