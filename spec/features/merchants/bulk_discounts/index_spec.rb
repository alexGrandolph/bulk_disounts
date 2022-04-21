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

    it 'I see all my bulk discounts and thier attributes, each is a link to their show page' do
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      merch5 = Merchant.create!(name: 'Corgi Town', created_at: DateTime.now, updated_at: DateTime.now, status: 0)
      
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch4.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch4.id)
      disc3 = BulkDiscount.create!(name: '5 for 20%', percentage: 20, threshold: 5, merchant_id: merch4.id)

      other_disc = BulkDiscount.create!(name: 'Other Merchants Discount', percentage: 5, threshold: 50, merchant_id: merch5.id)
      
      visit "/merchants/#{merch4.id}/bulk_discounts"
      # save_and_open_page
      expect(page).to_not have_content("Other Merchants Discount")

      within "#bulk_discount-#{disc1.id}" do 
        expect(page).to have_content("10 for 10%")
        expect(page).to have_content("Percent Off: 10")
        expect(page).to have_content("Minimum Quantity Threshold: 10")
        expect(page).to have_link("10 for 10%")
      end 
      within "#bulk_discount-#{disc2.id}" do 
        expect(page).to have_content("5 for 5%")
        expect(page).to have_content("Percent Off: 5")
        expect(page).to have_content("Minimum Quantity Threshold: 5")
        expect(page).to have_link("5 for 5%")

      end 
      within "#bulk_discount-#{disc3.id}" do 
        expect(page).to have_content("5 for 20%")
        expect(page).to have_content("Percent Off: 20")
        expect(page).to have_content("Minimum Quantity Threshold: 5")
        click_link "5 for 20%" 
      end 
      expect(current_path).to eq("/merchants/#{merch4.id}/bulk_discounts/#{disc3.id}")
    end
  end
  describe 'Creating a new bulk discount on bulk_discount index page' do
    
    it 'has a link to create a new bulk discount' do 
      merch4 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      visit "/merchants/#{merch4.id}/bulk_discounts"
      
      click_link "Create a New Bulk Discount"
      expect(current_path).to eq("/merchants/#{merch4.id}/bulk_discounts/new")
    
    end 


  end
end 