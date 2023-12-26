FactoryBot.define do
  factory :weather_datum do
    city { 'Moscow' }
    temperature { 20 }
    timestamp { Time.now }
  end
end
