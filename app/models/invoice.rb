class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  validates_presence_of :status
  validates_presence_of :created_at
  validates_presence_of :updated_at

  

  def customer_name
    first_name = "#{customer.first_name}"
    last_name ="#{customer.last_name}"
    "#{first_name} #{last_name}"
  end

  def self.incomplete_invoices
    joins(:invoice_items).where(status: [1]).order(:created_at)
  end

  def self.revenue_for_invoice(invoice_id)
    invoice = Invoice.find(invoice_id)
    invoice.invoice_items.sum('unit_price * quantity') / 100.to_f
  end

  def merchant_revenue_for_invoice(merchant)
    merchant.invoice_items.joins(:invoice).where("invoices.id = ?", self.id).sum('invoice_items.unit_price * invoice_items.quantity') / 100.to_f
    # merchant.invoice_items
    #         .sum('invoice_items.unit_price * invoice_items.quantity') / 100.to_f
  end
  
  def discount_amount_for_merchant(merchant)
    discount = merchants.where(id: merchant.id)
                        .joins(:bulk_discounts)
                        .where('invoice_items.quantity >= bulk_discounts.threshold')
                        .select('invoice_items.*')
                        .group('invoice_items.item_id')
                        .maximum('invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percentage / 100')
                        .pluck(1)
                        .sum
                        discount / 100.to_f
  end

  def merchant_revenue_after_discount(merchant)
    amount = discount_amount_for_merchant(merchant)
    total_revenue = merchant_revenue_for_invoice(merchant)
    total_revenue - amount
  end

  
  
  
end
