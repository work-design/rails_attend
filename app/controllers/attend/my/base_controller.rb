class Attend::My::BaseController < RailsAttend.config.my_controller.constantize
  before_action :require_member

  def require_member
    if current_member
      return
    end

    if current_user.blank?
      require_login_from_session and return
    else
      redirect_to my_root_url
    end
  end

end
