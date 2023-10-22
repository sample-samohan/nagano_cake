class Address < ApplicationRecord
  
  belongs_to :customer
  
  validates :customer_id, presence: true
  validates :post_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :name, presence: true
  
end
