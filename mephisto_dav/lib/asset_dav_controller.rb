require 'asset_resource'
class AssetDavController < Admin::BaseController

    act_as_railsdav 
    skip_before_filter :login_required

    before_filter :dav_auth

    def dav_auth()
      basic_auth_required do |username, password| 
        current_user ||= User.authenticate_for(site, username, password)  if username && password
        current_user.admin? unless current_user.nil?
      end
    end
    
    protected

    def write_content_to_path(davpath, content)
      #temp find for user
      current_user = User.find(:first, :order => 'id')
      begin
         require "tempfile"
         body = Tempfile.new('AssetDavController')
         File.open(body.path, "wb") { |f| f.write(content) }
         mimetype = MIME::Types.type_for(davpath).first.to_s
         mimetype = "application/octet-stream" if mimetype.blank?
         (class << body; self; end).class_eval do
           #alias local_path path
           define_method(:original_filename) {davpath.dup.taint}
           define_method(:content_type) {mimetype.dup.taint}
          end
         asset = site.assets.build({:uploaded_data => body, :user_id => current_user.id})
         asset.save!
       rescue Errno::ENOENT
          #Conflict
          raise WebDavErrors::ConflictError
       rescue Errno::EPERM
          #Forbidden
          raise WebDavErrors::ForbiddenError
       end
 
    end

    def get_resource_for_path(path)
       return AssetResource.new(path)
    end
end