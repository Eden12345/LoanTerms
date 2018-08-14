class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      sign_in(user)
      render json: user
    else
      render json: 'User did not save'
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :username)
  end
end
