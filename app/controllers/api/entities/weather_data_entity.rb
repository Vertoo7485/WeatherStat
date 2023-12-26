require 'grape-entity'

module Api
  module Entities
    class WeatherDataEntity < Grape::Entity
      expose :city
      expose :timestamp
      expose :temperature
    end
  end
end
