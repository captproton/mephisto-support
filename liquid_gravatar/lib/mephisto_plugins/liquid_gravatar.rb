module MephistoPlugins
  module TagCloud
    def gravatar(user, size=80)
      if RAILS_ENV == 'development'
        'mephisto/avatar.gif'
      else
        return 'mephisto/avatar.gif' unless user && user.email
        "http://www.gravatar.com/avatar.php?size=#{size}&gravatar_id=#{Digest::MD5.hexdigest(user.email)}&default=http://#{request.host_with_port}#{ActionController::AbstractRequest.relative_url_root}/images/mephisto/avatar.gif"
      end
    end
  end
end
