module ApplicationHelper
  def user_logged_in?
    User.find_by(id: cookies.encrypted[:user_id]).present?
  end

  def admin_logged_in?
    User.find_by(id: cookies.encrypted[:user_id]).try(:admin?)
  end

  def logged_in_user
    User.find_by(id: cookies.encrypted[:user_id])
  end

  def to_dollar(price)
    price.try(:/, 100)
  end

  def live_deal_exist?(deals)
    return true if deals.first.live?

  end
end
