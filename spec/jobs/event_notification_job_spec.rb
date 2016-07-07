require "rails_helper"

RSpec.describe EventNotificationJob, type: :job do
  let!(:event) { create(:paid_event, :with_participants_and_payments, participants_count: 5) }

  it "matches with enqueued job" do    
    expect {
      EventNotificationJob.perform_later
    }.to have_enqueued_job(EventNotificationJob)
  end

  it "matches with enqueued job" do
    expect {
      EventNotificationJob.set(:wait_until => Date.tomorrow.noon).perform_later
    }.to have_enqueued_job.at(Date.tomorrow.noon)
  end

  it 'sends email' do
    expect{EventNotificationJob.perform_now}.to change{ ActionMailer::Base.deliveries.count }.by(5)
  end
end