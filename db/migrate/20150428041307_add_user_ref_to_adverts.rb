class AddUserRefToAdverts < ActiveRecord::Migration
  def change
    add_reference :adverts, :user, index: true, foreign_key: true
  end
end
