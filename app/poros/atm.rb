class Atm
  attr_reader :name,
              :address,
              :lat,
              :lon,
              :distance,
              :id

  def initialize(attributes)
    @name = attributes[:name]
    @address = attributes[:address]
    @lat = attributes[:lat]
    @lon = attributes[:lon]
    @distance = attributes[:distance]
    @id = nil
  end
end