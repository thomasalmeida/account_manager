class AddReferredByToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :referred_by, :string
  end
end
