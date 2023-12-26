require 'rails_helper'
require 'vcr'
require 'rest-client'

RSpec.describe 'Weather API', type: :request do
  describe 'GET /api/weather/current' do
    context 'when there is data in the database and when you connect to the Api' do
      let!(:weather_datum) { create(:weather_datum) }

      it 'returns the current temperature from database' do
        get '/api/weather/current'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('city', 'timestamp', 'temperature')
        expect(json_response['temperature']).to eq(weather_datum.temperature)
      end

      it 'returns the current temperature from Api' do
        VCR.use_cassette('current') do
          API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
          url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
          get '/api/weather/current', headers: { 'X-Yandex-API-Key': API_KEY }

          RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })

          expect(response).to have_http_status(:ok)
          expect(response.body).to include('city', 'timestamp', 'temperature')
          expect(json_response['temperature']).to eq(weather_datum.temperature)
        end
      end
    end
  end

  describe 'GET /api/weather/historical' do
    context 'when there is data in the database and when you connect to the Api' do
      let!(:weather_data) { create_list(:weather_datum, 5) }

      it 'returns hourly temperature for the last 24 hours from database' do
        get '/api/weather/historical'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('city', 'timestamp', 'temperature')
        expect(json_response.size).to eq(5)
      end

      it 'returns hourly temperature for the last 24 hours from Api' do
        VCR.use_cassette('historical') do
          API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
          url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
          get '/api/weather/historical', headers: { 'X-Yandex-API-Key': API_KEY }

          RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })

          expect(response).to have_http_status(:ok)
          expect(response.body).to include('city', 'timestamp', 'temperature')
          expect(json_response.size).to eq(5)
        end
      end
    end
  end

  describe 'GET /api/weather/max' do
    context 'when there is data in the database and when you connect to the Api' do
      let!(:weather_data) { create_list(:weather_datum, 5) }

      it 'returns the maximum temperature for the last 24 hours from database' do
        get '/api/weather/max'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('max_temperature')
        expect(json_response['max_temperature']).to eq(weather_data.max_by(&:temperature).temperature)
      end

      it 'returns the maximum temperature for the last 24 hours from Api' do
        VCR.use_cassette('max') do
          API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
          url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
          get '/api/weather/max', headers: { 'X-Yandex-API-Key': API_KEY }

          RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })

          expect(response).to have_http_status(:ok)
          expect(response.body).to include('max_temperature')
          expect(json_response['max_temperature']).to eq(weather_data.max_by(&:temperature).temperature)
        end
      end
    end
  end

  describe 'GET /api/weather/min' do
    context 'when there is data in the database and when you connect to the Api' do
      let!(:weather_data) { create_list(:weather_datum, 5) }

      it 'returns the minimum temperature for the last 24 hours from database' do
        get '/api/weather/min'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('min_temperature')
        expect(json_response['min_temperature']).to eq(weather_data.min_by(&:temperature).temperature)
      end

      it 'returns the minimum temperature for the last 24 hours from Api' do
        VCR.use_cassette('min') do
          API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
          url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
          get '/api/weather/min', headers: { 'X-Yandex-API-Key': API_KEY }

          RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })

          expect(response).to have_http_status(:ok)
          expect(response.body).to include('min_temperature')
          expect(json_response['min_temperature']).to eq(weather_data.min_by(&:temperature).temperature)
        end
      end
    end
  end

  describe 'GET /api/weather/avg' do
    context 'when there is data in the database and when you connect to the Api' do
      let!(:weather_data) { create_list(:weather_datum, 5) }

      it 'returns the average temperature for the last 24 hours from database' do
        get '/api/weather/avg'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('avg_temperature')
        expect(json_response['avg_temperature'].to_f).to eq(weather_data.sum(&:temperature) / weather_data.size.to_f)
      end

      it 'returns the average temperature for the last 24 hours from Api' do
        VCR.use_cassette('avg') do
          API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
          url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
          get '/api/weather/avg', headers: { 'X-Yandex-API-Key': API_KEY }

          RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('avg_temperature')
          expect(json_response['avg_temperature'].to_f).to eq(weather_data.sum(&:temperature) / weather_data.size.to_f)
        end
      end
    end
  end

  describe 'GET /api/weather/by_time' do
    context 'when there is data in the database and when you connect to the Api' do
      let!(:weather_data) { create(:weather_datum, city: 'Moscow', timestamp: Time.current) }

      it 'returns the temperature closest to the given timestampfrom database' do
        timestamp = weather_data.timestamp.to_i
        get '/api/weather/by_time', params: { timestamp: }
        expect(response).to have_http_status(:ok)
        expect(json_response['city']).to eq('Moscow')
      end

      it 'returns the temperature closest to the given timestamp from Api' do
        VCR.use_cassette('by_time') do
          API_KEY = '205cb876-2e1a-44a9-aae2-6c84789b8420'
          url = 'https://api.weather.yandex.ru/v2/forecast?lat=55.7558&lon=37.6173&'
          timestamp = weather_data.timestamp.to_i

          get '/api/weather/by_time', headers: { 'X-Yandex-API-Key': API_KEY }, params: { timestamp: }

          RestClient.get(url, { 'X-Yandex-API-Key': API_KEY })

          expect(response).to have_http_status(:ok)
          expect(json_response['city']).to eq('Moscow')
        end
      end

      it 'returns an error if temperature not found' do
        timestamp = Time.new(2022, 1, 1).to_i
        get '/api/weather/by_time', params: { timestamp: }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Temperature not found')
      end
    end
  end

  describe 'GET /api/health' do
    it 'returns the status of the API' do
      get '/api/health'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('status', 'ok')
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
