class User < ApplicationRecord
  has_many :todos, primary_key: :number, foreign_key: :user_number, dependent: :destroy

  def completed
    todos.where(completed: true).count
  end  
end
