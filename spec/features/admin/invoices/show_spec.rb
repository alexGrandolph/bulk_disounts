require 'rails_helper'

RSpec.describe 'the admin invoice show page' do
  it 'shows the invoice information including invoice id, status, created_at in readable format and customer first and last name' , :vcr do
    merchant_1 = Merchant.create!(name: "Elron Hubbard", created_at: Time.now, updated_at: Time.now)
    customer_1 = Customer.create!(first_name: "Squeaky", last_name: "Clean", created_at: Time.now, updated_at: Time.now)
    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
    invoice_1 = FactoryBot.create(:invoice, created_at: Time.now, customer_id: customer_1.id)
    invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)
    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_content("Invoice Id: #{invoice_1.id}")
    expect(page).to have_content("Status: #{invoice_1.status}")
    expect(page).to have_content("Created: #{invoice_1.formatted_created_at}")
    expect(page).to have_content("Customer First Name: #{customer_1.first_name}")
    expect(page).to have_content("Customer Last Name: #{customer_1.last_name}")
  end

  describe 'As an Admin' do
    before do
      @merchant_1 = create(:merchant)
      @customer_1 = create(:customer)
      @invoice_1 = create(:invoice, status: 1, customer_id: @customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_11 = create(:item, merchant_id: @merchant_1.id)
      @item_111 = create(:item, merchant_id: @merchant_1.id)
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 0, quantity: 1, unit_price: 101)
      @invoice_item_11 = create(:invoice_item, item_id: @item_11.id, invoice_id: @invoice_1.id, status: 1, quantity: 2, unit_price: 201)
      @invoice_item_111 = create(:invoice_item, item_id: @item_111.id, invoice_id: @invoice_1.id, status: 2, quantity: 3, unit_price: 300)

      visit "/admin/invoices/#{@invoice_1.id}"

    end

    it 'lists the item names on the invoice' , :vcr do
      expect(page).to have_content("#{@item_1.name}")
      expect(page).to have_content("#{@item_11.name}")
      expect(page).to have_content("#{@item_111.name}")
    end

    it 'shows the unit price and quantity sold for each item', :vcr do
      expect(page).to have_content("Price: $1.01")
      expect(page).to have_content("Price: $2.01")
      expect(page).to have_content("Price: $3.00")
      expect(page).to have_content("Quantity sold: 1")
      expect(page).to have_content("Quantity sold: 2")
      expect(page).to have_content("Quantity sold: 3")
      expect(page).to have_content("Status: packaged")
      expect(page).to have_content("Status: pending")
      expect(page).to have_content("Status: shipped")
    end

    it 'will return total revenue from this invoice', :vcr do
      expect(page).to have_content("Total Revenue: $14.03")
    end

    it 'shows invoice status in a select field, and I can select a new status', :vcr do
      expect(page).to have_content("Invoice Status: in progress")
        within("#invoice_status_update")do
          expect(find_field('invoice_status').value).to eq('in progress')
          select('completed')
          click_button('Submit')
        end
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
        within("#invoice_status_update") do
          expect(page).to have_content("Invoice Status: completed")
        end
    end
  end

  describe 'Bulk Discounts, As a Visitor' do
    
    it 'Shows Total Revenue before and after discounts are applied' do

      custy = Customer.create!(first_name: 'Elron', last_name: 'Hubbard', created_at: DateTime.now, updated_at: DateTime.now)
      invoice1 = Invoice.create!(status: 1, customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      merch1 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      item3 = merch1.items.create!(name: 'Alot of Cheese', description: "It's cheese", unit_price: 200, created_at: Time.now, updated_at: Time.now)

      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 5, merchant_id: merch1.id)
      disc2 = BulkDiscount.create!(name: '5 for 20%', percentage: 20, threshold: 10, merchant_id: merch1.id)
      
      invoice_item_1 = InvoiceItem.create(item_id: item1.id, unit_price: item1.unit_price, quantity: 10, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_2 = InvoiceItem.create(item_id: item2.id, unit_price: item2.unit_price, quantity: 6, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_3 = InvoiceItem.create(item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      merch2 = Merchant.create!(name: 'Cheese Corp', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item5 = merch2.items.create!(name: "Brisket", description: "just a brisket", unit_price: 500, created_at: Time.now, updated_at: Time.now)
      item6 = merch2.items.create!(name: "Pork Belly", description: "extra bacon, bacon", unit_price: 250, created_at: Time.now, updated_at: Time.now)
      disc3 = BulkDiscount.create!(name: '4 for 20%', percentage: 20, threshold: 2, merchant_id: merch2.id)
      
      invoice_item_5 = InvoiceItem.create(item_id: item5.id, unit_price: item5.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_6 = InvoiceItem.create(item_id: item6.id, unit_price: item6.unit_price, quantity: 1, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      #this invoice and item should not be part of the calculation
      invoice2 = Invoice.create!(customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_6 = InvoiceItem.create!(item_id: item3.id, invoice_id: invoice2.id, quantity: 55, unit_price: item3.unit_price, created_at: DateTime.now, updated_at: DateTime.now)

      visit "/admin/invoices/#{invoice1.id}"
      # save_and_open_page
      expect(page).to have_content("Total Revenue: $38.50")
      expect(page).to have_content("Total Revenue After Discounts: $33.30")
    end 


  end
end
