class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token

  def create
    @new_user = User.create(user_params)
    if @new_user.valid?
      render json: @new_user.as_json, status: :created
    else
      render json: @new_user.errors.messages, status: :bad_request
    end
  end

  def user_params
    params.permit(:email, :name, :password, :country)
  end
end