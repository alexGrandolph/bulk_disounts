require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit Page' do

  describe 'As a Visitor' do

    it 'I fill in the form, Submitting takes me back to the bulk discount index, I see the changes', :vcr do
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch5.id)
      
      visit "/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}"
      click_on "Edit This Bulk Discount"
      fill_in "Name", with: "Updated 50% Off"
      fill_in "Percentage", with: 50
      fill_in "Threshold", with: 14
      click_on "Update"
      expect(current_path).to eq("/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}")
      #sad path
      expect(page).to_not have_content("10 for 10%")
      expect(page).to_not have_content("Percent Off: 10")
      expect(page).to_not have_content("Minimum Item Quantity Threshold: 10")

      expect(page).to have_content("Name of Discount: Updated 50% Off")
      expect(page).to have_content("Percent Off: 50")
      expect(page).to have_content("Minimum Item Quantity Threshold: 14")
    end 

    it 'Will not allow for editing percentage above 100', :vcr do 
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch5.id)
      
      visit "/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}"
      click_on "Edit This Bulk Discount"
      fill_in "Name", with: "Updated 50% Off"
      fill_in "Percentage", with: 200
      fill_in "Threshold", with: 14
      click_on "Update"
     
      expect(current_path).to eq("/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}/edit")
      expect(page).to have_content("BAD! Discount Percentage Must Be Greater Than 0 AND Less Than 100")
    end 

    it 'Will not allow for editing percentage to be a negative number', :vcr do 
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch5.id)
      
      visit "/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}"
      click_on "Edit This Bulk Discount"
      fill_in "Name", with: "Updated 50% Off"
      fill_in "Percentage", with: -100
      fill_in "Threshold", with: 14
      click_on "Update"
     
      expect(current_path).to eq("/merchants/#{merch5.id}/bulk_discounts/#{disc1.id}/edit")
      expect(page).to have_content("BAD! Discount Percentage Must Be Greater Than 0 AND Less Than 100")

    end 
  end 
end 