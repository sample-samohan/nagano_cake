class Item < ApplicationRecord
    
    has_many :cart_items, dependent: :destroy
    has_many :order_details, dependent: :destroy
    belongs_to :genre
    has_many :orders, through: :order_details
    has_many :customers, through: :cart_items

    has_one_attached :image
    
    def get_image(width, height)
      unless image.attached?
        file_path = Rails.root.join("app/assets/images/no_image.jpg")
        image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
      end
      image.variant(resize_to_fill: [width, height], gravity: :center).processed
    end




    validates :name, presence: true
    validates :explanation, presence: true
    validates :non_taxed_price, presence: true, format: { with: /\A[0-9]+\z/i,} #半角数字のみ登録可能
    
    
    def add_tax_non_taxed_price
        (self.non_taxed_price * 1.10).round
    end
    
    
end
