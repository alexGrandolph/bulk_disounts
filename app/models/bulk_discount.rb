class BulkDiscount < ApplicationRecord
  
  validates_presence_of :name 
  validates_presence_of :percentage, comparison: { greater_than: 1, less_than: 100}
  validates_presence_of :threshold, numbericality: true
  validates_presence_of :created_at
  validates_presence_of :updated_at

  belongs_to :merchant

end 