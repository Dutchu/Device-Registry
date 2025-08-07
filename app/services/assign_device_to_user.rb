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

    if DeviceAssignment.exists?(device_id: device.id, returned_at: nil)
      raise AssigningError::AlreadyUsedOnOtherUser # Or a more generic "AlreadyAssigned" error
    end

    if DeviceAssignment.exists?(device_id: device.id, user_id: new_device_owner_id, returned_at: !nil)
      raise AssigningError::AlreadyUsedOnUser
    end

    DeviceAssignment.create!(
      device: device,
      user_id: new_device_owner_id
    )

    # device.update!(user_id: new_device_owner_id)
  end

  private

  attr_reader :requesting_user, :serial_number, :new_device_owner_id
end
