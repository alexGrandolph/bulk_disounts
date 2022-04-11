require 'rails_helper'


RSpec.describe 'Merchant Invoice Index Page' do
  before do
    @merch1 = FactoryBot.create(:merchant)
    @merch2 = FactoryBot.create(:merchant)
    @cust1 = FactoryBot.create(:customer)
    @item1 = FactoryBot.create(:item, merchant_id: @merch1.id)
    @item2 = FactoryBot.create(:item, merchant_id: @merch1.id)
    @item3 = FactoryBot.create(:item, merchant_id: @merch1.id)
    @item4 =FactoryBot.create(:item, merchant_id: @merch2.id)
    @item5 = FactoryBot.create(:item, merchant_id: @merch2.id)

    @invoice1 = FactoryBot.create(:invoice, customer_id: @cust1.id)
    @invoice_item_1 = FactoryBot.create(:invoice_item, item_id: @item1.id, invoice_id: @invoice1.id)

    @invoice2 = FactoryBot.create(:invoice, customer_id: @cust1.id)
    @invoice_item_2 = FactoryBot.create(:invoice_item, item_id: @item5.id, invoice_id: @invoice2.id)
    @invoice_item_3 = FactoryBot.create(:invoice_item, item_id: @item2.id, invoice_id: @invoice2.id)

    @invoice3 = FactoryBot.create(:invoice, customer_id: @cust1.id)
    @invoice_item_4 = FactoryBot.create(:invoice_item, item_id: @item4.id, invoice_id: @invoice3.id)

    @invoice4 = FactoryBot.create(:invoice, customer_id: @cust1.id)
    @invoice_item_5 = FactoryBot.create(:invoice_item, item_id: @item1.id, invoice_id: @invoice4.id)
    @invoice_item_6 = FactoryBot.create(:invoice_item, item_id: @item2.id, invoice_id: @invoice4.id)

  end
  describe 'As a visitor' do

    it 'I see all invoices with atleast one of my items, I see the invoice ID and links' do

      visit "/merchants/#{@merch1.id}/invoices"
      expect(page).to have_content("Invoice ID: #{@invoice1.id}")
      expect(page).to have_content("Invoice ID: #{@invoice2.id}")
      expect(page).to have_content("Invoice ID: #{@invoice4.id}")
      expect(page).to have_content("Invoice ID: #{@invoice4.id}")

      # save_and_open_page

    end

  end




end
