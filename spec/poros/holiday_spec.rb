require 'rails_helper'

RSpec.describe Holiday do
  it "exists and has attributes" do
    data = [{localName: 'cheese day', date: '02-08-2022'}, {localName: 'brisket day', date: '11-11-1111'}]
    holidays = Holiday.new(data)

    expect(holidays).to be_a(Holiday)
    expect(holidays.next_holidays).to be_a(Hash)
    expect(holidays.next_holidays['cheese day']).to eq('02-08-2022')

  end
end