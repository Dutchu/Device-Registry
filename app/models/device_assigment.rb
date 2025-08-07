# frozen_string_literal: true
class DeviceAssigment < ActiveRecord
  belongs_to :device
  belongs_to :user
end