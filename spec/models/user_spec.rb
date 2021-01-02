require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(username: 'johndoe', password: 'secret') }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without an username' do
    subject.username = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a password' do
    subject.password = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with an username duplicate' do
    User.create!(username: 'johndoe', password: 'secret')
    
    expect(subject.save).to be_falsey

    User.delete_all
  end
end
