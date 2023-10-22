class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :items
  
  enum payment_method: { credit_card: 0, transfer: 1 }
  enum status: { waiting_for_payment: 0, confirmation_of_payment: 1, in_production: 2, preparing_to_ship: 3, shipped: 4  }
end
