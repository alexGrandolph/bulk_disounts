require 'rails_helper'


RSpec.describe 'Merchant Invoice Show Page' do

  describe 'As a visitor' do

    it 'I see the invoices id, status, formated created at date, customer first and last name' , :vcr do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, created_at: Time.now, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      # save_and_open_page
      expect(page).to have_content("Invoice ID: #{invoice1.id}")
      expect(page).to have_content("Status: #{invoice1.status}")
      expect(page).to have_content("Created At: #{invoice1.formatted_created_at}")
      expect(page).to have_content("Customer Name: #{invoice1.customer_name}")
    end

    it 'I see ONLY items that are mine and those items attributes' , :vcr do
      merch1 = FactoryBot.create(:merchant)
      merch2 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, merchant_id: merch1.id)
      item4 = FactoryBot.create(:item, merchant_id: merch2.id)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item3.id, invoice_id: invoice1.id)
      invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item4.id, invoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      # require "pry"; binding.pry
      expect(page).to have_content("My Items on This Invoice:")
      # save_and_open_page
      within "#invoice_item-#{invoice_item_1.id}" do
        expect(page).to have_content("Item Name: #{item1.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item_1.quantity}")
        expect(page).to have_content("Item Price: #{invoice_item_1.price_to_dollars}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item_1.status}")
      end
      within "#invoice_item-#{invoice_item_2.id}" do
        expect(page).to have_content("Item Name: #{item2.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item_2.quantity}")
        expect(page).to have_content("Item Price: #{invoice_item_2.price_to_dollars}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item_2.status}")
      end
      within "#invoice_item-#{invoice_item_3.id}" do
        expect(page).to have_content("Item Name: #{item3.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item_3.quantity}")
        expect(page).to have_content("Item Price: #{invoice_item_3.price_to_dollars}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item_3.status}")
      end

      expect(page).to_not have_content("#{item4.name}")
      expect(page).to_not have_content("#{invoice_item_4.price_to_dollars}")

    end

    it 'I see the total revenue that will be generated from all my items on the invoice' , :vcr do
      merch1 = FactoryBot.create(:merchant)
      # merch2 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, unit_price: 65734, merchant_id: merch1.id)
      # item4 = FactoryBot.create(:item, unit_price: 45345, merchant_id: merch2.id)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, unit_price: item2.unit_price, quantity: 1, invoice_id: invoice1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id)
      # invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item4.id, unit_price: item4.unit_price, quantity: 1, nvoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      expect(page).to have_content("Total Revenue From This Invoice:")
      within "#total_revenue" do
        expect(page).to have_content("Revenue: $4167.88")
      end
    end

    it 'has a drop down menu for each invoice item status, to change said status', :vcr do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, unit_price: item1.unit_price, quantity: 3, status: 0, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, unit_price: item2.unit_price, quantity: 1, status: 1, invoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      expect(page).to have_button("Update Item Status")

      within "#invoice_item-#{invoice_item_1.id}" do
        expect(find_field('status').value).to eq('packaged')
        select 'shipped'
        click_button 'Update Item Status'
      end
      expect(current_path).to eq("/merchants/#{merch1.id}/invoices/#{invoice1.id}")

      within "#invoice_item-#{invoice_item_1.id}" do
        expect(page).to have_content("shipped")
      end
    end
  end

# bulk discounts 

  describe "Bulk Discounts, As a Visitor on Merchant/Invoice Show Page" do

    it 'I see a total revenue calculation with discounts included and without' do
      custy = Customer.create!(first_name: 'Elron', last_name: 'Hubbard', created_at: DateTime.now, updated_at: DateTime.now)
      merch1 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      item3 = merch1.items.create!(name: 'Alot of Cheese', description: "It's cheese", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      item4 = merch1.items.create!(name: 'Not Cheese', description: "It is NOT cheese", unit_price: 2000, created_at: Time.now, updated_at: Time.now)

      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch1.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch1.id)
      disc3 = BulkDiscount.create!(name: '5 for 20%', percentage: 20, threshold: 5, merchant_id: merch1.id)

      invoice1 = Invoice.create!(status: 0, customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_1 = InvoiceItem.create(item_id: item1.id, unit_price: item1.unit_price, quantity: 11, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_2 = InvoiceItem.create(item_id: item2.id, unit_price: item2.unit_price, quantity: 5, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_3 = InvoiceItem.create(item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)

      #this invoice and item should not be part of the calculation
      invoice2 = Invoice.create!(customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_2 = InvoiceItem.create!(item_id: item4.id, invoice_id: invoice2.id, quantity: 55, unit_price: item4.unit_price, created_at: DateTime.now, updated_at: DateTime.now)
      
      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      # save_and_open_page
      expect(page).to have_content("Revenue: $25.00")
      expect(page).to have_content("Revenue After Discount: $20.80")
    end


  end
end
