class AddAdvertRefToImage < ActiveRecord::Migration
  def change
    add_reference :images, :advert, index: true, foreign_key: true
  end
end
