FactoryBot.define do
  factory :user_reward do
    redeemed { false }
    identifier { SecureRandom.hex(20) }
    association :user, factory: :user
    association :reward, factory: :reward
  end
end