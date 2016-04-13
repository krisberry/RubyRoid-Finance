class Invitation < ActiveRecord::Base
  scope :should_expire, -> { where("updated_at < ?",  (Time.now - 36.hours)) }
 
  def expired
    updated_at + 2.days
  end

  def will_expired?
    (expired - 12.hours) < Time.now
  end
end
