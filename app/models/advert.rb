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
  STATES = %w{for_sale reserved sold }

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end

    define_method("#{state}!") do
      self.state = state
      self.save
    end
  end
end
