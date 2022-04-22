class BulkDiscount < ApplicationRecord
  
  validates_presence_of :name 
  validates_presence_of :percentage
  validates_numericality_of :percentage, less_than_or_equal_to: 100
  validates_numericality_of :percentage, greater_than_or_equal_to: 1
  validates_presence_of :threshold, numbericality: true


  belongs_to :merchant

end 

# x = Merchant.create!(name: 'bob', created_at: DateTime.now, updated_at: DateTime.now)
# y = BulkDiscount.create!(name: 'wahoo', percentage: 140, threshold: 5, updated_at: DateTime.now, created_at: DateTime.now, merchant_id: x.id)