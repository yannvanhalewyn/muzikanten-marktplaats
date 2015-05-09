class Advert < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :images, dependent: :destroy
  belongs_to :user

  validates_presence_of :title, :description, :user_id
  validates :description, length: { minimum: 10 }
  validates :title, length: { minimum: 3 }

  # ======
  # states
  # ======
  def for_sale?
    self.state == "for_sale"
  end
  def sold?
    self.state == "sold"
  end
  def reserved?
    self.state == "reserved"
  end
  def for_sale!
    self.state = "for_sale"
  end
  def sold!
    self.state = "sold"
  end
  def reserved!
    self.state = "reserved"
  end
end
