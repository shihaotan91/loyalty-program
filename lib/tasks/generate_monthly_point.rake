namespace :monthly_task do
  desc 'Create Rewards'
  task create_monthly_point: :environment do
    User.each do |user|
      user.create_monthly_point
    end
  end
end