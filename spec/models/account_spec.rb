require 'rails_helper'

RSpec.describe Account, type: :model do
  subject do
    described_class.new(
      cpf: '12345678910',
      name: 'john doe',
      email: 'john@mail.com',
      birth_date: '2000-01-01',
      gender: 'undefined',
      city: 'Sao Paulo',
      state: 'SP',
      country: 'Brazil'
    )
  end

  after(:all) { Account.delete_all }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a cpf' do
    subject.cpf = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid wit an email incorrect' do
    subject.email = 'mail.com'
    expect(subject).to_not be_valid
  end

  it 'is not valid with a cpf duplicate' do
    described_class.create!(cpf: '12345678910')
    
    expect(subject.save).to be_falsey
  end

  it 'is not valid with an email duplicate' do
    described_class.create!(cpf: '12345678911', email: 'john@mail.com')
    
    expect(subject.save).to be_falsey
  end
end
