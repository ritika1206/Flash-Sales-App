module ApplicationHelper
  def user_logged_in?
    cookies[:user_id].present?
  end

  def admin_logged_in?
    User.find_by(id: cookies.encrypted[:user_id]).try(:admin?)
  end

  def logged_in_user
    User.find_by(id: cookies.encrypted[:user_id])
  end
end
