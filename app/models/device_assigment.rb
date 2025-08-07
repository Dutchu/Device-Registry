# frozen_string_literal: true
class DeviceAssigment < ApplicationRecord
  belongs_to :device
  belongs_to :user
end