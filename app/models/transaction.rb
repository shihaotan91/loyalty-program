class Transaction < ApplicationRecord
  before_create :calculate_leftover_spent

  POINTS_REWARD = {
    money_spent_in_cents: 10000,
    points_earned: 10
  }.freeze

  belongs_to :user

  validates_inclusion_of :country, in: Country.all
  validates_numericality_of :total_spent_in_cents, allow_nil: false

  def calculate_leftover_spent
    self.leftover_spent_in_cents = total_spent_in_cents % POINTS_REWARD[:money_spent_in_cents]
  end

  def calculate_points_earned
    (total_spent_in_cents % POINTS_REWARD[:money_spent_in_cents]).floor * POINTS_REWARD[:points_earned]
    # add code to assign user current monthly points with points
  end
end