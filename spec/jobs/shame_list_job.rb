require "rails_helper"

RSpec.describe ShameListJob, type: :job do
  let!(:event) { create(:paid_event, :with_participants_and_payments, participants_count: 5) }

  it "matches with enqueued job" do    
    expect {
      ShameListJob.perform_later
    }.to have_enqueued_job(ShameListJob)
  end

  it "matches with enqueued job" do
    expect {
      ShameListJob.set(:wait_until => Date.tomorrow.noon).perform_later
    }.to have_enqueued_job.at(Date.tomorrow.noon)
  end

  it 'sends email' do
    expect{ShameListJob.perform_now}.to change{ ActionMailer::Base.deliveries.count }.by(5)
  end
end