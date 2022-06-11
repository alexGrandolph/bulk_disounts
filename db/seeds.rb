# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Merchant.destroy_all
Customer.destroy_all
BulkDiscount.destroy_all
Invoice.destroy_all
Item.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all

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
