# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  # Define the service call as the subject of the test.
  subject(:return_device) do
    described_class.new(
      user: returning_user,
      serial_number: device.serial_number,
      from_user_id: returning_user.id
    ).call
  end

  let!(:device) { create(:device) }
  let!(:owner) { create(:user) }
  let!(:other_user) { create(:user) }

  context 'when the user returning the device is the current owner' do
    let(:returning_user) { owner }

    # Create an active assignment for the owner before each test in this context.
    let!(:assignment) do
      created_assigment = DeviceAssignment.create!(device: device, user: owner)
      device.update!(user: owner)
      created_assigment
    end

    it 'updates the returned_at timestamp on the assignment' do
      expect { return_device }.to change { assignment.reload.returned_at }.from(nil)
    end

    it 'clears the user_id on the device' do
      expect { return_device }.to change { device.reload.user_id }.from(owner.id).to(nil)
    end
  end

  context 'when a user tries to return a device owned by someone else' do
    let(:returning_user) { other_user }

    # Create an active assignment for the owner.
    let!(:assignment) do
      created_assigment = DeviceAssignment.create!(device: device, user: owner)
      device.update!(user: owner)
      created_assigment
    end

    it 'does not change the returned_at timestamp' do
      # We expect that calling the service does NOT change the timestamp.
      expect { return_device }.not_to change { assignment.reload.returned_at }
    end

    it 'does not change the user_id on the device' do
      # We expect that the owner of the device does not change.
      expect { return_device }.not_to change { device.reload.user_id }
    end
  end

  context 'when a user tries to return a device that is not assigned' do
    let(:returning_user) { other_user }

    it 'does not raise an error and does nothing' do
      # We expect that calling the service when there are no assignments
      # completes successfully without changing anything or raising an error.
      expect { return_device }.not_to raise_error
    end
  end
end
