class Item < ApplicationRecord
    
    has_many :cart_items, dependent: :destroy
    has_many :order_details, dependent: :destroy
    belongs_to :genre
    has_many :orders, through: :order_details
    has_many :customers, through: :cart_items

    has_one_attached :image
    
    def add_tax_non_taxed_price
        (self.non_taxed_price * 1.10).round
    end
    
    
end
