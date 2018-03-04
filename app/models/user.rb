class User < ApplicationRecord
  enum role: [:guest, :user, :admin]

  has_many :entries, dependent: :destroy

  # Admin
  has_many :winners, dependent: :nullify
  has_many :prizes, dependent: :destroy

  validates_presence_of :name
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: Devise::email_regexp  }
  validates :password, presence: true,
                       length: { within: 8..20 },
                       if: :validate_password?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def validate_password?
    new_record? || password.present?
  end
end
