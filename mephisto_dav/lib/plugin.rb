module Mephisto
  module Plugins
    class MephistoDav < Mephisto::Plugin
      author 'Stuart Eccles'
      version '0.1'
      
      public_controller 'ThemeDav'
      public_controller 'AssetDav'
      add_route 'theme_dav/*path_info', :controller => 'theme_dav', :action => 'webdav'
      add_route 'asset_dav/*path_info', :controller => 'asset_dav', :action => 'webdav'
    end
  end
end
