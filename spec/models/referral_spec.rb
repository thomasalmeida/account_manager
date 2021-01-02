require 'rails_helper'

RSpec.describe Referral, type: :model do
  subject { described_class.new(referral_code: 'a1b2c3d4', accounts_referred: [{id: 2, name: 'name'}]) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without an referral code' do
    subject.referral_code = nil
    expect(subject).to_not be_valid
  end
end
