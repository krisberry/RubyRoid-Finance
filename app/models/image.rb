
class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  has_attached_file :photo, styles: { thumb: ["250x"]}
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end