# spec/factories/device.rb

FactoryBot.define do
  factory :device do
    sequence(:serial_number) { |n| "DEVICE-SN-#{n}" }

    user { nil }
  end
end