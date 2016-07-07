require "rails_helper"

RSpec.describe BirthdayEventsJob, type: :job do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, :with_coming_birthday) }

  it "matches with enqueued job" do    
    expect {
      BirthdayEventsJob.perform_later
    }.to have_enqueued_job(BirthdayEventsJob)
  end

  it "matches with enqueued job" do
    expect {
      BirthdayEventsJob.set(:wait_until => Date.tomorrow.noon).perform_later
    }.to have_enqueued_job.at(Date.tomorrow.noon)
  end

  it 'sends email' do
    expect{BirthdayEventsJob.perform_now}.to change{ ActionMailer::Base.deliveries.count }
  end

  it 'creates an event' do
    expect{BirthdayEventsJob.perform_now}.to change{ Event.count }
  end
end