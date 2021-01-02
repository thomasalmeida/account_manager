class AccountsController < ApplicationController
  before_action :authorized
  before_action :set_account, only: [:update]

  def create
    unless cpf_valid?(params[:cpf])
      return render json: {message: 'invalid cpf, enter only 11 digits'}, status: :unprocessable_entity
    end
  
    @account = Account.new(account_params)
   
    if @account.save
      if is_complete?
        response = complete_account
        add_referral unless @account.referred_by.nil?

        return response
      end

      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    if e.message == 'Validation failed: Referral code has already been taken'
      @account.referral_code = SecureRandom.hex(4)
      @account.save!

      render json: @account, status: :created
    else
      render json: {message: e.message}, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      if is_complete?
        response = complete_account
        add_referral unless @account.referred_by.nil?

        return response
      end

      render json: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    if e.message == 'Validation failed: Referral code has already been taken'
      @account.referral_code = SecureRandom.hex(4)
      @account.save!

      render json: @account
    else
      render json: {message: e.message}, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.permit(:name, :email, :cpf, :birth_date, :gender, :city, :state, :country, :referred_by)
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def cpf_valid?(str)
    str !~ /\D/ && str.size == 11
  end

  def is_complete?
    @account
      .attributes
      .deep_symbolize_keys
      .slice(:name, :email, :cpf, :birth_date, :gender, :city, :state, :country)
      .values
      .each{ |attribute| return false if attribute.nil?}

    true
  end

  def complete_account
    @account.status = 'completed'
    @account.referral_code = SecureRandom.hex(4)

    @account.save!

    render json: {
      message: 'account created successfully',
      referral_code: @account.referral_code,
      cpf: @account.cpf,
      email: @account.email
    }
  end

  def add_referral
    ReferralsController.insert_referral(@account.referred_by, @account.id, @account.name)
  end
end
