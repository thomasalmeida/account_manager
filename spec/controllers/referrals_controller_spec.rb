require 'rails_helper'

RSpec.describe ReferralsController, type: :controller do
  before do
    allow_any_instance_of(ReferralsController).to receive(:logged_in?).and_return(:true)
  end

  before(:all) do
    5.times do
      cpf = rand(10000000000..99999999999).to_s
      Account.create!(
        cpf: cpf,
        name: 'john doe',
        email: "#{cpf}@mail.com",
        birth_date: '2000-01-01',
        gender: 'undefined',
        city: 'Sao Paulo',
        state: 'SP',
        country: 'Brazil',
        status: 'completed',
        referral_code: SecureRandom.hex(4),
        referred_by: Account.all.sample&.referral_code
      )
    end
  end

  after(:all) do
    Referral.delete_all
    Account.delete_all
  end

  describe 'insert_referral' do
    describe 'with valid params' do
      it 'inserts a referral' do
        referred = Account.where.not(referred_by: nil).sample
        account = Account.where(referral_code: referred.referred_by).first

        expect {
          ReferralsController.insert_referral(referred.referral_code, account.id, account.name)
        }.to change(Referral, :count).by(1)

        referral = Referral.find_by(referral_code: referred.referral_code)
        expect(referral.referral_code).to eq referred.referral_code
        expect(referral.accounts_referred).to eq [{'id'=>account.id, 'name'=>account.name}]
      end
    end
  end

  describe 'GET #list_referrals' do
    describe 'with valid params' do
      it 'lists referrals by referral code' do
        referred = Account.where.not(referred_by: nil).sample
        account = Account.where(referral_code: referred.referred_by).first
        ReferralsController.insert_referral(referred.referral_code, account.id, account.name)

        get :list_referrals, params: { code: referred.referral_code }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match(
          {
            'referral_code'=>referred.referral_code,
            'accounts_referred'=>[{'id'=>account.id, 'name'=>account.name}]
          }
        )
      end
    end

    describe 'with invalid params' do
      it 'returns a error message' do
        get :list_referrals, params: { code: 'xxxxxx' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to match(
          { 'message' => 'not found' }
        )
      end
    end
  end
end
