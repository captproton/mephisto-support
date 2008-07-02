require 'open-uri'
require 'action_controller/vendor/html-scanner/html/document' unless Object.const_defined?(:HTML) && HTML.const_defined?(:Document)
      
module ArticleImageFetchyMethods
  include_into "Article"
  
  def self.included(base)
    base.before_save :store_remote_images_as_assets
  end
  
  protected
    def store_remote_images_as_assets
      body_doc.find_all(:tag => 'img').each do |img|
        begin
          if img['src'].match(/^https?:\//) # save everything with a http://
            open img['src'] do |file|
              asset = site.assets.build(:filename => File.basename(img['src']), :temp_data => file.read, :content_type => file.content_type, :tag => 'remote')
              asset.save!
              body.gsub!(img['src'], asset.public_filename)
              self.body_html = FilteredColumn::Processor.process_filter(filter, body.dup)
              logger.debug "Replaced #{img['src']} with #{asset.public_filename}"
            end
          end
        rescue
          logger.warn "Error replacing article image: #{$1}"
          logger.info $!.backtrace.collect { |b| " > #{b}" }.join("\n")
        end
      end
    end
end