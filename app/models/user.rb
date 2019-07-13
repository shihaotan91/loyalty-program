class User < ApplicationRecord
  has_many :monthly_points

  after_create :create_monthly_point
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_inclusion_of :country, in: Country.all

  def create_monthly_point
    MonthlyPoint.create!(user_id: id)
  end

  def current_monthly_point
    monthly_points.find_by(start_date: Date.today.beginning_of_month)
  end
end
