class Item < ApplicationRecord
    
    has_many :cart_item, dependent: :destroy
    has_many :order_detail, dependent: :destroy
    belongs_to :genres
    has_many :orders, through: :order_details

    has_one_attached :image
    

    
end
