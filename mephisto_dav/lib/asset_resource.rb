# Copyright (c) 2006 Stuart Eccles
# Released under the MIT License.  See the LICENSE file for more details.

require 'find'
class AssetResource
  include WebDavResource

   attr_accessor :href, :asset
   
   WEBDAV_PROPERTIES = [:displayname, :creationdate, :getlastmodified, :getcontenttype, :getcontentlength]
   
   def initialize(*args)
       obj = args.first
       
       #bit hackey but kind_of? ActiveRecord::Base isnt working
       if obj.respond_to? :filename
         @asset = obj
         @href = "#{@asset.filename}"
       else
         if obj == '' or obj == '/'
           @href = ''
         else
           path_asset = Asset.find_by_filename(obj)
           raise WebDavErrors::NotFoundError if path_asset.blank?
           @asset = path_asset
           @href = "#{path_asset.filename}"
         end
       end
    end

    def collection?
      @href == ''
    end

    def delete!
      asset.destroy unless asset.nil?
    end


    def move! (dest_path, depth)
      
    end

    def copy! (dest_path, depth)
      
    end

    def children
     return [] unless collection?

     #Return children of all the assets
     return Asset.find( :all ).map { |o| AssetResource.new(o) } 
    end
  
   def properties
     WEBDAV_PROPERTIES
   end 

   def displayname 
      return asset.filename unless asset.nil?
   end
   
   def creationdate
      if !asset.nil? and asset.respond_to? :created_at
        asset.created_at.httpdate
      end
   end
   
   def getlastmodified
      if !asset.nil? and asset.respond_to? :updated_at
        asset.updated_at.httpdate
      end
   end
   
   def set_getlastmodified(value)
     if !asset.nil? and asset.respond_to? :updated_at=
      asset.updated_at = Time.httpdate(value)
      gen_status(200, "OK").to_s
     else
        gen_status(409, "Conflict").to_s
     end
   end
   
   def getetag
      #sprintf('%x-%x-%x', @st.ino, @st.size, @st.mtime.to_i) unless @file.nil?
   end
      
   def getcontenttype
      collection? ? "httpd/unix-directory" : (asset.content_type unless asset.nil?)
   end
      
   def getcontentlength 
      asset.size unless asset.nil?
   end
   
   def data
     unless asset.nil?
       return File.new(asset.full_filename)
     end
   end

   
end