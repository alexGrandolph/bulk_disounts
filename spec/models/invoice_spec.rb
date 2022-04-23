require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:created_at) }
    it { should validate_presence_of(:updated_at) }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'instance and class methods' do
    it 'returns the invoices created at date as Weekday, Month Day, Year' do
      date = 	"2020-02-08 09:54:09 UTC".to_datetime
      cust1 = FactoryBot.create(:customer, first_name: "L'Ron", last_name: 'Hubbard')
      merch1 = FactoryBot.create(:merchant)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, created_at: date, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)

      expect(invoice1.formatted_created_at).to eq("Saturday, February  8, 2020")
    end

    it 'returns the invoice customers first and last name together' do
      date = 	"2020-02-08 09:54:09 UTC".to_datetime
      cust1 = FactoryBot.create(:customer, first_name: "L'Ron", last_name: 'Hubbard')
      merch1 = FactoryBot.create(:merchant)
      item1 = FactoryBot.create(:item, id: 69, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, created_at: date, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)

      expect(invoice1.customer_name).to eq("L'Ron Hubbard")
    end
  end

  describe "incomplete invoices" do
    it 'returns a list of all cancelled and in progress invoices' do
        @merchant_1 = create(:merchant)
        @item = create(:item, merchant_id: @merchant_1.id)

        # customer_1, 6 succesful transactions and 1 failed
        @customer_1 = create(:customer)
        @invoice_1 = create(:invoice,status: 0, customer_id: @customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
        @invoice_item_1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id, status: 2)
        @transactions_list_1 = FactoryBot.create_list(:transaction, 6, invoice_id: @invoice_1.id, result: 0)
        @failed_1 = create(:transaction, invoice_id: @invoice_1.id, result: 1)

        # customer_2 5 succesful transactions
        @customer_2 = create(:customer)
        @invoice_2 = create(:invoice, status: 2, customer_id: @customer_2.id, created_at: "2012-03-25 09:54:09 UTC")
        @invoice_item_2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id, status: 1)
        transactions_list_2 = FactoryBot.create_list(:transaction, 5, invoice_id: @invoice_2.id, result: 0)
        #customer_3 4 succesful
        @customer_3 = create(:customer)
        @invoice_3 = create(:invoice, status: 1,customer_id: @customer_3.id, created_at: "2012-03-25 09:54:09 UTC")
        @invoice_item_3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id, status: 2)
        @transactions_list_3 = FactoryBot.create_list(:transaction, 4, invoice_id: @invoice_3.id, result: 0)

      expect(Invoice.incomplete_invoices).to eq([@invoice_3])

    end

    it '#self.incomplete_invoices returns invoices ordered from oldest to newest' do
      @merchant_1 = create(:merchant)
      @item = create(:item, merchant_id: @merchant_1.id, )

      # customer_1, 6 succesful transactions and 1 failed
      @customer_1 = create(:customer)
      @invoice_1 = create(:invoice, status: 0, customer_id: @customer_1.id, created_at: "2015-03-25 09:54:09 UTC")
      @invoice_item_1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id, status: 2)
      @transactions_list_1 = FactoryBot.create_list(:transaction, 6, invoice_id: @invoice_1.id, result: 0)
      @failed_1 = create(:transaction, invoice_id: @invoice_1.id, result: 1)

      #customer_3 4 succesful
      @customer_3 = create(:customer)
      @invoice_3 = create(:invoice, status: 1,customer_id: @customer_3.id, created_at: "2020-03-25 09:54:09 UTC")
      @invoice_item_3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id, status: 1)
      @transactions_list_3 = FactoryBot.create_list(:transaction, 4, invoice_id: @invoice_3.id, result: 0)

      # customer_2 5 succesful transactions
      @customer_2 = create(:customer)
      @invoice_2 = create(:invoice, status: 2, customer_id: @customer_2.id, created_at: "2016-03-25 09:54:09 UTC")
      @invoice_item_2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id, status: 2)
      transactions_list_2 = FactoryBot.create_list(:transaction, 5, invoice_id: @invoice_2.id, result: 0)


      #customer_4 3 succesful
      @customer_4 = create(:customer)
      @invoice_4 = create(:invoice, status: 1, customer_id: @customer_4.id, created_at: "2002-03-25 09:54:09 UTC")
      @invoice_item_4 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id, status: 1)
      @transactions_list_4 = FactoryBot.create_list(:transaction, 3, invoice_id: @invoice_4.id, result: 0)


      #customer_5 2 succesful
      @customer_5 = create(:customer)
      @invoice_5 = create(:invoice, status: 2, customer_id: @customer_5.id, created_at: "2019-03-25 09:54:09 UTC")
      @transactions_list_5 = FactoryBot.create_list(:transaction, 2, invoice_id: @invoice_5.id, result: 0)
      @invoice_item_5 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id, status: 2)

      #customer_6 1 succesful
      @customer_6 = create(:customer)
      @invoice_6 = create(:invoice, customer_id: @customer_6.id, status: 1, created_at: "2012-03-25 09:54:09 UTC")
      @invoice_item_6 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_6.id, status: 1)
      transactions_list_6 = FactoryBot.create_list(:transaction, 1, invoice_id: @invoice_6.id, result: 0)

      expect(Invoice.incomplete_invoices).to eq([@invoice_4, @invoice_6, @invoice_3])
    end
  end

  describe 'invoice revenue calculation' do
    xit 'calculates total revenue on invoice' do
        merch1 = FactoryBot.create(:merchant)
        merch2 = FactoryBot.create(:merchant)
        cust1 = FactoryBot.create(:customer)
        item1 = FactoryBot.create(:item, merchant_id: merch1.id, unit_price: 1000)
        item2 = FactoryBot.create(:item, merchant_id: merch1.id, unit_price: 1000)
        item3 = FactoryBot.create(:item, merchant_id: merch1.id, unit_price: 1000)
        item4 = FactoryBot.create(:item, merchant_id: merch2.id, unit_price: 1000)

        invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
        invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, unit_price: item1.unit_price, quantity: 1)
        invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, unit_price: item2.unit_price, quantity: 1)
        invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item3.id, invoice_id: invoice1.id, unit_price: item4.unit_price, quantity: 1)
        invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item4.id, invoice_id: invoice1.id, unit_price: item3.unit_price, quantity: 1)

        invoice2 = FactoryBot.create(:invoice, customer_id: cust1.id)
        invoice_item_5 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, unit_price: item2.unit_price, quantity: 10)
# require "pry"; binding.pry
        expect(Invoice.revenue_for_invoice(invoice2.id)).to eq(100.00)
        expect(Invoice.revenue_for_invoice(invoice1.id)).to eq(40.00)
      end
    end
  describe "bulk discounts, class and instance methods" do
    it 'returns a merchants revenue after applicable discounts for a given invoice' do
      custy = Customer.create!(first_name: 'Elron', last_name: 'Hubbard', created_at: DateTime.now, updated_at: DateTime.now)
      invoice1 = Invoice.create!(status: 1, customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      merch1 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      item3 = merch1.items.create!(name: 'Alot of Cheese', description: "It's cheese", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      # item4 = merch1.items.create!(name: 'Not Cheese', description: "It is NOT cheese", unit_price: 2000, created_at: Time.now, updated_at: Time.now)

      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch1.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch1.id)
      disc3 = BulkDiscount.create!(name: '5 for 20%', percentage: 20, threshold: 5, merchant_id: merch1.id)
      
      invoice_item_1 = InvoiceItem.create(item_id: item1.id, unit_price: item1.unit_price, quantity: 10, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_2 = InvoiceItem.create(item_id: item2.id, unit_price: item2.unit_price, quantity: 6, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_3 = InvoiceItem.create(item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      merch2 = Merchant.create!(name: 'Cheese Corp', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item5 = merch2.items.create!(name: "Brisket", description: "just a brisket", unit_price: 500, created_at: Time.now, updated_at: Time.now)
      invoice_item_5 = InvoiceItem.create(item_id: item5.id, unit_price: item5.unit_price, quantity: 15, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      disc2 = BulkDiscount.create!(name: '4 for 60%', percentage: 60, threshold: 4, merchant_id: merch2.id)
      
      #this invoice and item should not be part of the calculation
      # invoice2 = Invoice.create!(customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      # invoice_item_6 = InvoiceItem.create!(item_id: item4.id, invoice_id: invoice2.id, quantity: 55, unit_price: item4.unit_price, created_at: DateTime.now, updated_at: DateTime.now)

      expect(invoice1.discount_revenue_for_merchant(merch1.id)).to eq(21.90)
    end 
    
    it 'returns the invoice revenue for a given merchant' do
      custy = Customer.create!(first_name: 'Elron', last_name: 'Hubbard', created_at: DateTime.now, updated_at: DateTime.now)
      invoice1 = Invoice.create!(status: 1, customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      merch1 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      item3 = merch1.items.create!(name: 'Alot of Cheese', description: "It's cheese", unit_price: 200, created_at: Time.now, updated_at: Time.now)

      
      invoice_item_1 = InvoiceItem.create(item_id: item1.id, unit_price: item1.unit_price, quantity: 10, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_2 = InvoiceItem.create(item_id: item2.id, unit_price: item2.unit_price, quantity: 6, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_3 = InvoiceItem.create(item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      
      merch2 = Merchant.create!(name: 'Cheese Corp', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item5 = merch2.items.create!(name: "Brisket", description: "just a brisket", unit_price: 500, created_at: Time.now, updated_at: Time.now)
      invoice_item_5 = InvoiceItem.create(item_id: item5.id, unit_price: item5.unit_price, quantity: 15, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      expect(invoice1.merchant_revenue_for_invoice(merch1)).to eq(26.0)
    end 
  end
end
