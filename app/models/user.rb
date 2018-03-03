class User < ApplicationRecord
  enum role: [:guest, :user, :admin]

  has_many :entries, dependent: :destroy

  # Admin
  has_many :winners, dependent: :nullify
  has_many :prizes, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
