require 'rails_helper'

RSpec.describe 'the admin invoice show page' do
  it 'shows the invoice information including invoice id, status, created_at in readable format and customer first and last name' do
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

  describe 'As an Admin' do
    before do
      @merchant_1 = create(:merchant)
      @customer_1 = create(:customer)
      @invoice_1 = create(:invoice, status: 1, customer_id: @customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_11 = create(:item, merchant_id: @merchant_1.id)
      @item_111 = create(:item, merchant_id: @merchant_1.id)
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 1)
      @invoice_item_11 = create(:invoice_item, item_id: @item_11.id, invoice_id: @invoice_1.id, status: 1)
      @invoice_item_111 = create(:invoice_item, item_id: @item_111.id, invoice_id: @invoice_1.id, status: 1)

      visit "/admin/invoices/#{@invoice_1.id}"
    end

    it 'lists the item names on the invoice' do
      expect(page).to have_content("#{@item_1.name}")
      expect(page).to have_content("#{@item_11.name}")
      expect(page).to have_content("#{@item_111.name}")
    end

    it 'shows the unit price and quantity sold for each item' do
      expect(page).to have_content("#{@item_1.unit_price}")
      expect(page).to have_content("#{@item_11.unit_price}")
      expect(page).to have_content("#{@item_111.unit_price}")
      expect(page).to have_content("#{@invoice_item_1.quantity}")
      expect(page).to have_content("#{@invoice_item_11.quantity}")
      expect(page).to have_content("#{@invoice_item_111.quantity}")
    end
  end
end
