require "rails_helper"

RSpec.describe SentNotificationAboutDeletingInvitationJob, type: :job do
  let!(:invitation) { create(:should_be_deleted_invitation) }

  it "matches with enqueued job" do    
    expect {
      SentNotificationAboutDeletingInvitationJob.perform_later
    }.to have_enqueued_job(SentNotificationAboutDeletingInvitationJob)
  end

  it "matches with enqueued job" do
    send_time = Time.now + 1.hours
    expect {
      SentNotificationAboutDeletingInvitationJob.set(:wait_until => send_time).perform_later
    }.to have_enqueued_job.at(send_time)
  end

  it 'sends email' do
    expect{SentNotificationAboutDeletingInvitationJob.perform_now}.to change{ ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'delete invitation after sending email' do
    expect{SentNotificationAboutDeletingInvitationJob.perform_now}.to change{ Invitation.count }.by(-1)
  end
end