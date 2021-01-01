class ReferralsController < ApplicationController
  def self.insert_referral(referral_code, id, name)
    referral = Referral.find_or_create_by!(referral_code: referral_code)
    referral.accounts_referred.push({id: id, name: name})

    return true if referral.save

    false
  end
end
