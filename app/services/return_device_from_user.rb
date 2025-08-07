# frozen_string_literal: true

class ReturnDeviceFromUser

  def initialize(user:, serial_number:, from_user_id:)
    @user = user
    @serial_number = serial_number
    @from_user_id = from_user_id
  end

  def call
    device = Device.find_by(serial_number: serial_number)
    return unless device

    if device.user_id == from_user_id
      device.previous_owner_ids << from_user_id
      device.save!
      device.update!(user_id: nil)
    end
  end

  private attr_reader :user, :serial_number, :from_user_id
end