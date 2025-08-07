# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized unless new_device_owner_id == requesting_user.id

    device = Device.find_or_create_by!(serial_number: serial_number)

    if device.previous_owner_ids.include?(new_device_owner_id)
      raise AssigningError::AlreadyUsedOnUser
    end

    raise AssigningError::AlreadyUsedOnOtherUser if device.user_id.present? && device.user_id != new_device_owner_id
    raise AssigningError::AlreadyUsedOnUser if device.user_id == new_device_owner_id

    DeviceAssigment.create!(
      device: device,
      user_id: new_device_owner_id,
      assigned_at: Time.current
    )

    requesting_user.devices << device
  end

  private

  attr_reader :requesting_user, :serial_number, :new_device_owner_id
end
