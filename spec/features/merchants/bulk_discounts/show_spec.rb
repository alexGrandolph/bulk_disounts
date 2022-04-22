require 'rails_helper'


RSpec.describe 'Merchant Bulk Discount Show Page' do

  describe 'As a Visitor' do

    it 'I see the bulk discounts name, percentage, and attributes' do
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch5.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch5.id)
      
      visit "/merchants/#{merch5.id}/bulk_discounts/#{disc2.id}"
      # save_and_open_page
      expect(page).to_not have_content("10 for 10%")
      expect(page).to_not have_content("#{disc1.percentage}")
      expect(page).to_not have_content("#{disc1.threshold}")

      expect(page).to have_content("Name of Discount: 5 for 5%")
      expect(page).to have_content("Percent Off: 5")
      expect(page).to have_content("Minimum Item Quantity Threshold: 5")
    end 
  end
  
  describe 'Editing a Bulk Discount' do

    it 'I click the link to edit the discount, taking me to a new page with a form' do
      
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch5.id)
      
      visit "/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}"
      click_on "Edit This Bulk Discount"
      save_and_open_page
      expect(current_path).to eq("/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}/edit")


    end



  end 
end 