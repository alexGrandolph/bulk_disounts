require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:created_at) }
    it { should validate_presence_of(:updated_at) }
  end

  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe 'instance methods' do

    it 'returns an invoice_items unit_price to dollars / formatted' do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = Item.create!(name: 'Eldens Ring', description: 'its a ring', unit_price: 75107, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, unit_price: item1.unit_price, item_id: item1.id, invoice_id: invoice1.id)
      expect(invoice_item_1.price_to_dollars).to eq(751.07)

    end
  end

  describe 'Bulk Discounts Instance Methods' do

    it '#has_discount? returns true if an invoice item has an applicable discount' do
      custy = Customer.create!(first_name: 'Elron', last_name: 'Hubbard', created_at: DateTime.now, updated_at: DateTime.now)
      merch1 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch1.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch1.id)
      disc3 = BulkDiscount.create!(name: '5 for 20%', percentage: 20, threshold: 5, merchant_id: merch1.id)

      
      invoice1 = Invoice.create!(status: 0, customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_1 = InvoiceItem.create(item_id: item1.id, unit_price: item1.unit_price, quantity: 1, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_2 = InvoiceItem.create(item_id: item2.id, unit_price: item2.unit_price, quantity: 16, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)

      expect(invoice_item_2.has_discount?).to eq(true)
      expect(invoice_item_1.has_discount?).to eq(false)
    end

    it '#discount returns the highest percentage applicable discount for an invoice_item' do
      custy = Customer.create!(first_name: 'Elron', last_name: 'Hubbard', created_at: DateTime.now, updated_at: DateTime.now)
      merch1 = Merchant.create!(name: 'My Dog Skeeter', created_at: DateTime.now, updated_at: DateTime.now, status: 1)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      
      disc1 = BulkDiscount.create!(name: '10 for 10%', percentage: 10, threshold: 10, merchant_id: merch1.id)
      disc2 = BulkDiscount.create!(name: '5 for 5%', percentage: 5, threshold: 5, merchant_id: merch1.id)
      disc3 = BulkDiscount.create!(name: '5 for 20%', percentage: 20, threshold: 5, merchant_id: merch1.id)

      invoice1 = Invoice.create!(status: 0, customer_id: custy.id, created_at: DateTime.now, updated_at: DateTime.now)
      invoice_item_1 = InvoiceItem.create(item_id: item2.id, unit_price: item2.unit_price, quantity: 16, invoice_id: invoice1.id, created_at: DateTime.now, updated_at: DateTime.now)
      expect(invoice_item_1.discount).to eq(disc3)
      expect(invoice_item_1.discount.id).to eq(disc3.id)

    end

  end 

end
