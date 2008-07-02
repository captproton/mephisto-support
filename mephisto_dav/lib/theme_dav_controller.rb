class ThemeDavController < Admin::BaseController
  act_as_filewebdav :base_dir => 'themes'
  
  skip_before_filter :login_required
  before_filter :dav_auth

  def dav_auth()
    basic_auth_required do |username, password| 
      current_user ||= User.authenticate_for(site, username, password)  if username && password
      current_user.admin? unless current_user.nil?
    end
  end
  
end
