class MonthlyPoint < ApplicationRecord
  belongs_to :user

  before_create :generate_start_and_end_dates

  def generate_start_and_end_dates
    today = Date.today
    self.start_date = today.beginning_of_month
    self.end_date = today.end_of_month
  end
end