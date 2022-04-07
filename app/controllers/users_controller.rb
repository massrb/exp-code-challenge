class UsersController < ApplicationController
  def index
    Todo.load_json if User.count.zero?
    @users = User.all.order("percent_complete DESC")
  end
end
