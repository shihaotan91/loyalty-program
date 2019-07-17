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

### Leftover Spending

I presume that spendings could be accumulated over transactions for users to exchange every $100 they have spent into points. Eg. If users spend $50 in two transactions, they should still be able to redeem their points.

To allow this, I decided to create a `LeftoverSpending` model to track money that was spent by the user that haven't been converted into points. Leftover spendings are seperated into two columns either `local_spent_in_cents` or `overseas_spent_in_cents` since we are suppose to give double the points if it's a overseas spending.

Once the LeftoverSpending hits 10000cents(or $100) in either field. We will convert them to points and calculate the remaining spendings left. This is being done in a `ActiveRecord::Base.transaction` block to avoid a "double spending" problem. 

The same principle applies for updating monthly points and calculating leftover spending on the `Transaction` model

### I18n

To avoid cases of magic number/string.

I used `I18n` to store the names of rewards and the points/spending requriements to earn them. This would also standardize the values of those string/numbers




