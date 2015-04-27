class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :image
      t.string :fb_profile_url
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps null: false
    end
  end
end
