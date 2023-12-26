require 'grape'

module Api
  class WeatherApi < Grape::API
    prefix 'api'
    format :json

    resource :weather do
      desc 'Returns the current temperature'
      get :current do
        weather_data = WeatherDatum.where(city: 'Moscow').order(timestamp: :desc).first
        present weather_data, with: Api::Entities::WeatherDataEntity
      end

      desc 'Returns hourly temperature for the last 24 hours'
      get :historical do
        weather_data = WeatherDatum.where(city: 'Moscow').where('timestamp >= ?', 24.hours.ago).order(timestamp: :asc)
        present weather_data, with: Api::Entities::WeatherDataEntity
      end

      desc 'Returns the maximum temperature for the last 24 hours'
      get :max do
        max_temperature = WeatherDatum.where(city: 'Moscow').where('timestamp >= ?', 24.hours.ago).maximum(:temperature)
        { max_temperature: }
      end

      desc 'Returns the minimum temperature for the last 24 hours'
      get :min do
        min_temperature = WeatherDatum.where(city: 'Moscow').where('timestamp >= ?', 24.hours.ago).minimum(:temperature)
        { min_temperature: }
      end

      desc 'Returns the average temperature for the last 24 hours'
      get :avg do
        avg_temperature = WeatherDatum.where(city: 'Moscow').where('timestamp >= ?', 24.hours.ago).average(:temperature)
        { avg_temperature: }
      end

      desc 'Returns the temperature closest to the given timestamp'
      params do
        requires :timestamp, type: Integer, desc: 'Timestamp in seconds since epoch'
      end
      get :by_time do
        timestamp = Time.at(params[:timestamp])
        weather_data = WeatherDatum.where(city: 'Moscow').where('timestamp >= ? and timestamp <= ?',
                                                                timestamp.beginning_of_hour, timestamp.end_of_hour).first
        error!('Temperature not found', 404) unless weather_data
        present weather_data, with: Api::Entities::WeatherDataEntity
      end
    end

    resource :health do
      desc 'Returns the status of the API'
      get do
        { status: 'ok' }
      end
    end
  end
end
