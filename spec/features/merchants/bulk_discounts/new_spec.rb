require 'rails_helper'


RSpec.describe 'Merchant Bulk Discount New Page' do

  describe 'As a Visitor, Creating a New Bulk Discount' do

    it 'I fill in a form and I am redirected back to the index, with the new discount shown', :vcr do
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch4.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch4.id)

      visit "/merchants/#{merch4.id}/bulk_discounts"
     
      click_link "Create a New Bulk Discount"
      fill_in "Name", with: "New 50 for 50"
      fill_in "Percentage", with: 50
      fill_in "Threshold", with: 50
      click_on "Submit"
      expect(current_path).to eq("/merchants/#{merch4.id}/bulk_discounts")
      # save_and_open_page
      expect(page).to have_content("New 50 for 50")
    end 
    #sad path
    it 'Will not allow for a discount percentage to be greater than 100', :vcr do
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch4.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch4.id)

      visit "/merchants/#{merch4.id}/bulk_discounts"
      
      click_link "Create a New Bulk Discount"
      fill_in "Name", with: "New 50 for 50"
      fill_in "Percentage", with: 101
      fill_in "Threshold", with: 5
      click_on "Submit"
      # save_and_open_page
      expect(current_path).to eq("/merchants/#{merch4.id}/bulk_discounts/new")
      expect(page).to have_content("It is company policy for discounts to be less than or eqaul to 100%")
    end
  end
end