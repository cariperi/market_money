class AtmsFacade
  attr_reader :market

  def initialize(market)
    @market = market
  end

  def atms
    create_atms(formatted_data)
  end

  private
    def service
      @_service ||= AtmService.new
    end

    def atm_data
      @_atm_data ||= service.find_atms(@market.lat, @market.lon)
    end

    def formatted_data
      atms = atm_data[:results]
      atms.map do |atm|
        data =  {
          name: atm[:poi][:name],
          address: atm[:address][:freeformAddress],
          lat: atm[:position][:lat],
          lon: atm[:position][:lon],
          distance: atm[:dist]
        }
      end
    end

    def create_atms(atms)
      atms.map do |atm_data|
        Atm.new(atm_data)
      end
    end
end