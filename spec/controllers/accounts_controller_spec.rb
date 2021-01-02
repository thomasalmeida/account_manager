require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  before do
    allow_any_instance_of(AccountsController).to receive(:logged_in?).and_return(:true)
  end

  before(:all) { @account = Account.create!(cpf: '11122233300') }
  after(:all) { Account.delete_all }

  let(:valid_attributes) {
    {
      cpf: '12345678910',
      name: 'john doe',
      email: 'john@mail.com',
      birth_date: '2000-01-01',
      gender: 'undefined',
      city: 'Sao Paulo',
      state: 'SP',
      country: 'Brazil'
    }
  }

  let(:update_attributes) {
    {
      name: 'john doe',
      email: 'john@mail.com',
      birth_date: '2000-01-01',
      gender: 'undefined',
      city: 'Sao Paulo',
      state: 'SP',
      country: 'Brazil'
    }
  }

  let(:incomplete_update_attributes) {
    {
      name: 'john doe',
      email: 'john@mail.com',
      gender: 'undefined',
      city: 'Sao Paulo',
      state: 'SP',
      country: 'Brazil'
    }
  }

  describe 'POST #create' do
    describe 'with valid params' do
      it 'creates a new Account' do
        expect {
          post :create, params: valid_attributes
        }.to change(Account, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match(
          {
            'message'=>'account created successfully',
            'referral_code'=>be_kind_of(String),
            'cpf'=>'12345678910',
            'email'=>'john@mail.com'
          }
        )
      end
    end

    describe 'with invalid params' do
      it 'returns a error message' do
        valid_attributes[:cpf] = nil

        expect {
          post :create, params: valid_attributes
        }.to change(Account, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to match(
          { 'message' => 'invalid cpf, enter only 11 digits' }
        )
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with incomplete valid params' do
      it 'updates an Account' do
        patch :update, params: { id: @account.id }.merge(incomplete_update_attributes)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match(
          {
            'id'=>@account.id,
            'name'=>'john doe',
            'email'=>'john@mail.com',
            'gender'=>'undefined',
            'city'=>'Sao Paulo',
            'state'=>'SP',
            'country'=>'Brazil',
            'referral_code'=>nil,
            'cpf'=>'11122233300',
            'birth_date'=>nil,
            'status'=>'pending',
            'created_at'=>be_kind_of(String),
            'updated_at'=>be_kind_of(String),
            'referred_by'=>nil
          }
        )
      end
    end

    describe 'with complete valid params' do
      it 'updates an Account' do
        patch :update, params: { id: @account.id }.merge(update_attributes)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match(
          {
            'message'=>'account created successfully',
            'referral_code'=>be_kind_of(String),
            'cpf'=>'11122233300',
            'email'=>'john@mail.com'
          }
        )
      end
    end
  end
end
