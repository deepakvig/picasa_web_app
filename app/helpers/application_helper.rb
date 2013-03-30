module ApplicationHelper

  def convert_date date
    date.to_date.strftime('%b %d, %Y')
  end

  def user_signed_in?
    false
  end

end
