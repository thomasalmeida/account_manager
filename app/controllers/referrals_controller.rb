class ReferralsController < ApplicationController
  before_action :authorized, except: [:insert_referral]

  def list_referrals
    list = Referral.find_by(referral_code: params[:code])

    return render json: {message: 'not found'}, status: :not_found if list.nil?

    render json: list.attributes.deep_symbolize_keys.slice(:referral_code, :accounts_referred)
  end

  def self.insert_referral(referral_code, id, name)
    referral = Referral.find_or_create_by!(referral_code: referral_code)
    referral.accounts_referred.push({id: id, name: name})

    return true if referral.save

    false
  end
end
