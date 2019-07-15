class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @new_transaction = Transaction.create(transaction_params)
    if @new_transaction.valid?
      render json: @new_transaction.as_json, status: :created
    else
      render json: @new_transaction.errors.messages, status: :bad_request
    end
  end

  def transaction_params
    params.permit(:total_spent_in_cents, :user_id, :country)
  end
end