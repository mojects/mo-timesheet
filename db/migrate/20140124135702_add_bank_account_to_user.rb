class AddBankAccountToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :external_user_id
      t.string :duty
      t.date :date_of_contract
      t.string :active
      t.float :tax_percent
      t.string :address
      t.string :city
      t.string :country
      t.string :zip
      t.string :name_for_bank_account
      t.string :bank_account_number
      t.string :bank_swift
      t.string :bank_name
    end
  end
end
