class SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(
      params[:username],
      params[:password]
    )

    if user
      sign_in(user)
      render json: [user.session_token]
    else
      render json: ['Invalid username or password']
    end
  end

  def destroy
    sign_out
    render json: ['Signed out']
  end
end
