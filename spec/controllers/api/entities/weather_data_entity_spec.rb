require 'rails_helper'

RSpec.describe Api::Entities::WeatherDataEntity do
  it 'exposes :city, :timestamp, and :temperature' do
    weather_data = WeatherDatum.new(city: 'Example City', timestamp: Time.current, temperature: 25.0)
    entity = described_class.represent(weather_data)

    expect(entity.as_json[:city]).to eq('Example City')
    expect(entity.as_json[:timestamp].to_time.to_i).to eq(Time.current.to_i)
    expect(entity.as_json[:temperature].to_f).to eq(25.0)
  end
end
