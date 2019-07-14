namespace :yearly_task do
  desc 'Create Rewards'
  task reset_loyalty_tier: :environment do
    User.all.each do |user|
      previous_points = [1, 2].map do |n|
        date = Date.today - n.year
        user.monthly_points.for_year(date).pluck(:points).sum
      end

      higher_point = previous_points.max

      user.upgrade_loyalty_tier(higher_point)
    end
  end
end