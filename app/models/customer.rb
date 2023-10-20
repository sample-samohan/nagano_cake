class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        
  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_active == true)
  end  
  
  has_many :cart_items, dependent: :destroy
  has_many :addresses, dependent: :destroy 

end
