class AtmService
  def find_atms(lat, lon)
    get_url("/search/2/categorySearch/automatic%20teller%20machine.json?lat=#{lat}&lon=#{lon}")
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com') do |f|
      f.params['key'] = ENV['TOMTOM_API_KEY']
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end