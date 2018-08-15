class UsersController < ApplicationController
  def create
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      sign_in(user)
      render json: ['You are now signed in']
    else
      render json: ['Usernames must be unique and passwords must be 2 or more characters']
    end
  end
end
