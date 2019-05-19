class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 	has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
   	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

   	validates :name, presence: true
   	validates :email, format:{with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "is badly formatted "}, uniqueness: true
   	validates :phone, numericality: { only_integer: true }, :allow_blank => true

 	has_many :paintings
end
