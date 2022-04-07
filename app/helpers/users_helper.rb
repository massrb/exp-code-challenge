module UsersHelper
  def class_for(user)
    user.percent_complete >= 50 ? "at-least-50" : "less-than-50"
  end
end
