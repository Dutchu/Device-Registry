class User < ApplicationRecord
  has_many :devices
  has_many :device_assignments
  has_many :devices, through: :device_assignments
  has_many :api_keys, as: :bearer
  has_secure_password
end
