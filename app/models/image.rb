class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  
  has_attached_file :photo, styles: { thumb: ["256x"], mini: ["76x76#"]}, default_url: ->(attachment) { ActionController::Base.helpers.asset_path("assets/:style/missing_avatar.png") }
  
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end