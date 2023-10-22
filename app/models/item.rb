class Item < ApplicationRecord
    
    has_many :cart_item, dependent: :destroy
    has_many :order_detail, dependent: :destroy
    belongs_to :genre
    has_many :orders, through: :order_details

    has_one_attached :image
    
    validates :name, presence: true
    validates :explanation, presence: true
    validates :non_taxed_price, presence: true, format: { with: /\A[0-9]+\z/i,} #半角数字のみ登録可能
    
    
    def add_tax_non_taxed_price
        (self.non_taxed_price * 1.10).round
    end
    
    
end
