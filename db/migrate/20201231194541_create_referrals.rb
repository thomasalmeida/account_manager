class CreateReferrals < ActiveRecord::Migration[6.0]
  def change
    create_table :referrals, id: false, primary_key: :referral_code do |t|
      t.string :referral_code, null: false, primary_key: true
      t.json :accounts_referred, array: true, default: []

      t.timestamps
    end

    add_index(:referrals, :referral_code)
  end
end
