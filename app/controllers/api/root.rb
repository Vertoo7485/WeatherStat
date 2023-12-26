require 'grape-swagger'

module Api
  class Root < Grape::API
    format :json
    mount Api::WeatherApi
    add_swagger_documentation
  end
end
