class AddStatesToAdverts < ActiveRecord::Migration
  def change
    remove_column :adverts, :sold_at, :datetime
    add_column :adverts, :state, :string, default: "for_sale"
  end
end
