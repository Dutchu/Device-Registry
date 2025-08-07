# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    # 1. Authorization check: User can only assign to self.
    raise RegistrationError::Unauthorized unless new_device_owner_id == requesting_user.id

    # 2. Find or create the device.
    device = Device.find_or_create_by!(serial_number: serial_number)

    # 3. Check all failure conditions based on product requirements.

    # Fail if it's currently assigned to a different user.
    if device.user_id.present? && device.user_id != new_device_owner_id
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    # Fail if it's already assigned to the current user.
    if device.user_id == new_device_owner_id
      raise AssigningError::AlreadyUsedOnUser
    end

    # Fail if this user has owned it before and returned it.
    if device.previous_owner_ids.include?(new_device_owner_id)
      raise AssigningError::AlreadyUsedOnUser
    end

    # 4. If all checks pass, perform the assignment directly.
    device.update!(user_id: new_device_owner_id)
  end

  private

  attr_reader :requesting_user, :serial_number, :new_device_owner_id
end
