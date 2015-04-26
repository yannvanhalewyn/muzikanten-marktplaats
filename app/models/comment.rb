class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :advert
  validates_presence_of :content, :user_id, :advert_id
end
