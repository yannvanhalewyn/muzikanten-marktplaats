class AddSoldFieldToAdvert < ActiveRecord::Migration
  def change
    add_column :adverts, :sold_at, :datetime
  end
end
