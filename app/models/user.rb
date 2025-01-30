class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relacionamento com reservas
  has_many :reservations, dependent: :destroy

  # Garantir que nome e e-mail sejam preenchidos e únicos
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Converter e-mails para minúsculas antes de salvar
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
