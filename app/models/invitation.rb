class Invitation < ActiveRecord::Base
  def expired
    updated_at + 2.days
  end

  def will_expired?
    expired < (Time.now - 12.hours)
  end
end
