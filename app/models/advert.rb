class Advert < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user

  validates_presence_of :title, :description, :user_id
  validates :description, length: { minimum: 10 }
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
