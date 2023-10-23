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
  has_many :orders, dependent: :destroy

  validates :family_name, presence: true, length: {maximum: 20}
  validates :first_name, presence: true, length: {maximum: 20}
  validates :family_name_kana, presence: true, length: {maximum: 20}, format: { with: /\p{katakana}/ } #全角カタカナのみ登録可能
  validates :first_name_kana, presence: true, length: {maximum: 20}, format: { with: /\p{katakana}/ } #全角カタカナ
  #validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :post_code, presence: true, format: { with: /\A\d{7}\z/ } #郵便番号（ハイフンなし7桁）のみ登録可能
  validates :address, presence: true, length: {maximum: 50}
  validates :telephone_number, presence: true, format: { with: /\A\d{10,11}\z/ } #電話番号（ハイフンなし10・11桁）のみ登録可能
end
