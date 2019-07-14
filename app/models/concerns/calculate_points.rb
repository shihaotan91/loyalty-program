module CalculatePoints
  POINTS_REWARD = {
    spent_required: 10000,
    points_earned: 10
  }.freeze

  def self.points_earned(spent_in_cents)
    (spent_in_cents / POINTS_REWARD[:spent_required]).floor * POINTS_REWARD[:points_earned]
  end

  def self.leftover_spent(spent_in_cents)
    spent_in_cents % POINTS_REWARD[:spent_required]
  end

  def self.spent_converted(spent_in_cents)
    return 0 if POINTS_REWARD[:spent_required] > spent_in_cents
    spent_in_cents - (spent_in_cents % POINTS_REWARD[:spent_required])
  end
end