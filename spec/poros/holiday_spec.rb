require 'rails_helper'

RSpec.describe Holiday do
  it "exists and has attributes" do
    data = [{localName: 'cheese day'}, {localName: 'brisket day'}]
    holidays = Holiday.new(data)
    expect(holidays).to be_a(Holiday)
    expect(holidays.next_holidays).to be_a(Array)
    expect(holidays.next_holidays[1]).to eq('brisket day')
  end
end