class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :ido_id
      t.text :first_name
      t.text :last_name
      t.text :locale
      t.text :email
      t.text :username
      t.text :crypted_password
      t.text :password_salt
      t.text :persistence_token

      t.timestamps
    end
  end
end
