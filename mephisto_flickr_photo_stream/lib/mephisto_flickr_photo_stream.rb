require 'flickr_picture_provider'

class FlickrPhotoStream < Liquid::Block
  def initialize(markup, tokens)
    super 
    @attributes = {
      :feed => 'http://api.flickr.com/services/feeds/photos_public.gne?id=57966634@N00&format=rss_200',
      :count => 6
      }
      
    markup.scan(Liquid::TagAttributes) do |key, value|
      @attributes[key.to_sym] = value
    end
  end

  def feed_url
    @attributes[:feed]
  end
  
  def count
    @attributes[:count].to_i
  end

  def render(context)
    result = []
    pics = find_pictures
    pics.each do |pic|
      context.stack do
        context['pic'] = pic
        result << render_all(@nodelist, context)
      end
    end

    result
  end
  
  protected
    def find_pictures
      FlickrPictureProvider.new(@attributes).choose(count)
    end
end

Liquid::Template.register_tag('flickrphotostream', FlickrPhotoStream)