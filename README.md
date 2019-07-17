# Loyalty Program

## The Application

This is a simple loyalty program application that allow users to claim rewards, earn points and upgrade their loyalty membership tier through transactions.

## Scope

I manage to cover every scope except for `Issuing Rewards 2.1(Birthday Coffee)` and `Loyalty Tier 2.4(100 Bonus points every quarterly)`

## Specs covered

I manage to write specs for Model associations, validations and their instance methods. I also wrote specs for all the services I created.

## Setup

Before running the application. Please run 

`rake setup:create_rewards` and `rake setup:create_loyalty_tier`

To create default rewards and loyalty tiers mentioned in the scope

## Design Implementations

### Whenever gem

I used the whenever gem in two scenerios

- To generate `MonthlyPoint` for users on a monthly basis
- To reset `LoyaltyTier` for users annually

Usually this could be done with a scheduler in your hosting environment

### RewardsTrigger

Based on the scope I covered. I identified that rewards can be earned via 3 ways

- Earning Monthly Points
- Spending in Transactions
- Upgrading Loyalty Tier

From that, I created 3 different kinds of service objects that would trigger as a model callback. 
After the object is initialize it would then give out rewards depending on whether reward criterias are met.

###I18n

To avoid cases of magic number/string.

I used `I18n` to store the names of rewards and the points/spending requriements to earn them. This would also standardize the values of those string/numbers




