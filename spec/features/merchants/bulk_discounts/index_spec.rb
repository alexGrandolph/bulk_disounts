require 'rails_helper'


RSpec.describe 'Merchant Bulk Discount Index Page' do

  describe 'As a Visitor' do
    it 'on my merchant dashboard I see a link to view all my discounts' do
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      
      visit "/merchants/#{merch4.id}/dashboard"

      click_link "View All My Discounts"
      expect(current_path).to eq("/merchants/#{merch4.id}/bulk_discounts")  
    end



  end
end 