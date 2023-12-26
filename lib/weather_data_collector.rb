require 'rest-client'

class WeatherDataCollector
  API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
  CITY = 'Moscow'

  def self.collect
    url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
    response = RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })

    json = JSON.parse(response.body)
    temperature = json['fact']['temp']
    timestamp = Time.at(json['now']).beginning_of_hour

    WeatherDatum.create(city: CITY, temperature:, timestamp:)
  end
end
