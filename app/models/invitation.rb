class Invitation < ActiveRecord::Base
  def expired
    created_at + 2.days
  end

  def expired?
    expired < Time.now
  end
end
