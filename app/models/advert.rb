class Advert < ActiveRecord::Base
  has_many :comments
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :title, length: { minimum: 3 }

  def sold?
    !sold_at.blank?
  end

  def toggle_sold!
    if sold?
      update_attribute(:sold_at, nil)
    else
      update_attribute(:sold_at, Time.now)
    end
  end
end
