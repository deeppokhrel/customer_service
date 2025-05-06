# spec/models/customer_spec.rb
require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it 'validates uniqueness of email' do
      create(:customer, email: 'test@example.com')
      duplicate = build(:customer, email: 'test@example.com')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include('has already been taken')
    end
  end

  describe 'Kafka events' do
    let(:customer) { build(:customer, email: 'kafka@example.com', name: 'Test', address: '123 Street', phone: '1234567890') }

    before do
      allow(KafkaProducer).to receive(:publish)
    end

    it 'publishes customer.created event after create' do
      customer.save!
      expect(KafkaProducer).to have_received(:publish).with(
        'customer-events',
        "{\"id\":#{customer.id},\"event_type\":\"customer.created\",\"email\":\"kafka@example.com\",\"address\":\"123 Street\",\"name\":\"Test\",\"phone\":\"1234567890\"}"
      )
    end

    it 'publishes customer.updated event after update' do
      customer.save!
      customer.update!(name: 'Updated Name')
      expect(KafkaProducer).to have_received(:publish).with(
        'customer-events',
        "{\"id\":#{customer.id},\"event_type\":\"customer.created\",\"email\":\"kafka@example.com\",\"address\":\"123 Street\",\"name\":\"Test\",\"phone\":\"1234567890\"}"
      )
    end

    it 'publishes customer.destroy event after destroy' do
      customer.save!
      customer.destroy
      expect(KafkaProducer).to have_received(:publish).with(
        'customer-events',
        { email: 'kafka@example.com', event_type: 'customer.destroy' }.to_json
      )
    end
  end
end
