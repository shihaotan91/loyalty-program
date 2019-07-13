class MonthlyPoint < ApplicationRecord
  belongs_to :user

  before_validation :generate_start_and_end_dates, on: :create

  validates :user_id, uniqueness: { scope: %i[start_date end_date] }

  def generate_start_and_end_dates
    today = Date.today
    self.start_date = today.beginning_of_month
    self.end_date = today.end_of_month.end_of_day
  end
end