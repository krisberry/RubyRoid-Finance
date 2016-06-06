require "rails_helper"

RSpec.describe "events/index" do
  let(:custom_event) { create(:custom_event,) }
  let(:paid_event) { create(:paid_event) }
  let(:admin) { create(:admin) }

  before do
    sign_in(admin)
    allow(view).to receive(:sort_link).and_return("text")
    assign(:events, [custom_event, paid_event])
  end

  it "displays all the events" do
    render template: 'events/index'

    expect(rendered).to include(custom_event.name)
    expect(rendered).to include(paid_event.name)
  end
end