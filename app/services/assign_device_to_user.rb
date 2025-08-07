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

    if device.user_id.present? && device.user_id != new_device_owner_id
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    if device.user_id == new_device_owner_id
      raise AssigningError::AlreadyUsedOnUser
    end

    device.update!(user_id: new_device_owner_id)
  end

  private

  attr_reader :requesting_user, :serial_number, :new_device_owner_id
end
