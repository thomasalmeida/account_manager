require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  def valid_attributes
    { username: 'userx', password: 'secretx' }
  end

  describe 'POST #create' do
    describe 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    describe 'with invalid params' do
      it 'returns a error message' do
        post :create, params: {}

        expect(response).to have_http_status(:ok)
        expect(response.body).to match "{\"error\":\"Invalid username or password\"}"
      end
    end
  end

  describe 'POST #login' do
    before(:all) { User.create!(valid_attributes) }
    after(:all) { User.delete_all }

    describe 'with valid params' do
      it 'returns a access token' do
        post :login, params: valid_attributes

        expect(response).to have_http_status(:ok)
        response_parsed = JSON.parse(response.body).deep_symbolize_keys!
        expect(response_parsed[:user]).to be_kind_of(Hash)
        expect(response_parsed[:user][:username]).to eq 'userx'
        expect(response_parsed[:token]).to be_kind_of(String)
      end
    end

    describe 'with invalid params' do
      it 'returns a error message' do
        post :login, params: {}

        expect(response).to have_http_status(:ok)
        expect(response.body).to match "{\"error\":\"Invalid username or password\"}"
      end
    end
  end
end
