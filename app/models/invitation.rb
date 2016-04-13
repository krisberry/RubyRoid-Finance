class Invitation < ActiveRecord::Base
  scope :should_expire, -> { where("updated_at < ?",  (Time.now - 36.hours)) }
  scope :should_delete, -> { where("updated_at < ?", (Time.now - 2.days))}
 
  def expired
    updated_at + 2.days
  end

  def will_expired?
    (expired - 12.hours) < Time.now
  end
end
