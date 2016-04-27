class Invitation < ActiveRecord::Base
  scope :should_expire, -> { where("updated_at < ? AND approved = ?", (Time.now - 36.hours), true) }
  scope :should_delete, -> { where("updated_at < ? AND approved = ?", (Time.now - 2.days), true) }
 
  validates :email, presence: true

  def expired
    updated_at + 2.days
  end

  def will_expired?
    ((expired - 12.hours) < Time.now) && approved?
  end
end
