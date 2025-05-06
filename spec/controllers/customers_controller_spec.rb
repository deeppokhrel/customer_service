# spec/controllers/customers_controller_spec.rb
require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  # Use FactoryBot to define test data
  let(:valid_attributes) { attributes_for(:customer) }
  let(:invalid_attributes) { attributes_for(:customer, :invalid) }
  let(:customer) { create(:customer) }

  describe 'GET #index' do
    before { create_list(:customer, 3) }

    it 'returns all customers' do
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to be_an(Array)
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  describe 'GET #show' do
    it 'returns the requested customer' do
      get :show, params: { id: customer.id }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(customer.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new customer' do
        expect {
          post :create, params: { customer: valid_attributes }
        }.to change(Customer, :count).by(1)
      end

      it 'returns created status' do
        post :create, params: { customer: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { name: 'Updated Name', email: 'updated@example.com' } }

    context 'with valid params' do
      it 'updates the customer' do
        put :update, params: { id: customer.id, customer: new_attributes }
        customer.reload
        expect(customer.name).to eq('Updated Name')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:customer_to_delete) { create(:customer) }

    it 'destroys the customer' do
      expect {
        delete :destroy, params: { id: customer_to_delete.id }
      }.to change(Customer, :count).by(-1)
    end
  end
end
