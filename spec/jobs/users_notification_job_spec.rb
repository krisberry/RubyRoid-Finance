require "rails_helper"

RSpec.describe UsersNotificationJob, type: :job do
  let!(:invitation) { create(:should_expire_invitation) }

  it "matches with enqueued job" do    
    expect {
      UsersNotificationJob.perform_later
    }.to have_enqueued_job(UsersNotificationJob)
  end

  it "matches with enqueued job" do
    send_time = Time.now + 1.hours
    expect {
      UsersNotificationJob.set(:wait_until => send_time).perform_later
    }.to have_enqueued_job.at(send_time)
  end

  it 'sends email' do
    expect{UsersNotificationJob.perform_now}.to change{ ActionMailer::Base.deliveries.count }.by(1)
  end
end