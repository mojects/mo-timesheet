class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :first_name
      t.string :last_name
      t.string :mail
      t.string :skype
      t.string :gtalk
      t.string :phone
      t.string :os

      t.timestamps
    end
  end
end
