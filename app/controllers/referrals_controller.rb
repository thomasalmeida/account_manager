class ReferralsController < ApplicationController
  before_action :authorized, except: [:insert_referral]

  def list_referrals
    list = Referral.find_by(referral_code: params[:code])

    render json: list.attributes.deep_symbolize_keys.slice(:referral_code, :accounts_referred)
  end

  def self.insert_referral(referral_code, id, name)
    referral = Referral.find_or_create_by!(referral_code: referral_code)
    referral.accounts_referred.push({id: id, name: name})

    return true if referral.save

    false
  end
end
