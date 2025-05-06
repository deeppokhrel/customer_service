class Customer < ApplicationRecord
  validates :email, uniqueness: true

  after_create :user_created_event
  after_destroy :user_destroy_event
  after_update :user_update_event

  private

  def user_created_event
    KafkaProducer.publish("customer-events", customer_payload("customer.created"))
  end

  def user_destroy_event
    KafkaProducer.publish("customer-events", { email: email, event_type: "customer.destroy" }.to_json)
  end

  def user_update_event
    KafkaProducer.publish("customer-events", customer_payload("customer.updated"))
  end

  def customer_payload(type)
    {
      id: id,
      event_type: type,
      email: email,
      address: address,
      name: name,
      phone: phone
    }.to_json
  end
end
