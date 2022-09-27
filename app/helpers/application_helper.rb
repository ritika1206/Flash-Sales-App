module ApplicationHelper
  def user_logged_in?
    cookies[:user_id].present?
  end
end
