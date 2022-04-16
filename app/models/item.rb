class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  enum status: { Disabled: 0, Enabled: 1 }

  validates_presence_of :name
  validates_presence_of :description, presence: true
  validates_presence_of :unit_price, presence: true
  validates_presence_of :created_at
  validates_presence_of :updated_at

  def new

  end

  # def total_sales(item_id)
  #   item = Item.find(item_id)
  #   item.invoice_items.sum('unit_price * quantity') / 100.to_f
  #   # joins(:invoice_items, invoices: :transactions)
  #   # .where(transactions: {result: 0})
  #   # .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price')
  #   # .group(:id)
  # end
end
