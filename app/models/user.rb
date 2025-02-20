class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :courts, foreign_key: :owner_id, dependent: :destroy

  # Garantir que nome e e-mail sejam preenchidos e únicos
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :phone_number, length: { minimum: 8 }, allow_blank: true


  # Corrigindo a sintaxe do enum para Rails 7
  enum :role, { client: 0, court_owner: 1, admin: 2 }

  # Converter e-mails para minúsculas antes de salvar
  before_save :downcase_email


  private

  def downcase_email
    self.email = email.downcase
  end
end
