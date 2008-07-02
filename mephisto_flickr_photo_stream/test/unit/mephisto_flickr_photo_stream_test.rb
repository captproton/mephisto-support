require 'test/unit'
require File.dirname(__FILE__) + '/../../../../../test/test_helper'
require File.dirname(__FILE__) + '/../mocks/flickr_aggregation'

class FlickrPhotoStreamTest < Test::Unit::TestCase
  def setup
    FlickrPictureProvider.stub_pics = [create_picture(:title => 'test title')]
  end
  
  def test_should_see_one_image_in_template_results
    assert_select render("{% flickrphotostream %}<img />{% endflickrphotostream %}"), 'img'
  end

  def test_should_see_medium_sized_image
    template = "{% flickrphotostream %}<img src='{{pic.medium}}' />{% endflickrphotostream %}"
    assert_select render(template), 'img[src="http://static.flickr.com/photos/my_image_d.jpg"]'
  end
  
  def test_should_see_multiple_images_when_feed_has_two_pictures
    FlickrPictureProvider.stub_pics = [create_picture, create_picture]
    
    template = "{% flickrphotostream %}<img src='{{pic.square}}' alt='{{pic.title}}' />{% endflickrphotostream %}"
    assert_select render(template), 'img', 2
  end
  
  def test_should_see_multiple_images_with_correct_titles
    FlickrPictureProvider.stub_pics = [create_picture(:title => 'first'), create_picture(:title => 'second')]
    template = "{% flickrphotostream %}<img alt='{{pic.title}}' />{% endflickrphotostream %}"
    assert_select render(template), 'img[alt="first"]'
    assert_select render(template), 'img[alt="second"]'
  end
  
  def test_should_render_empty_with_no_pictures
    FlickrPictureProvider.stub_pics = ''
    template = "{% flickrphotostream %}<img />{% endflickrphotostream %}"
    assert_equal '', render_template(template)
  end

  def test_should_use_default_photo_stream
    template = Liquid::Template.parse("{% flickrphotostream %}<img />{% endflickrphotostream %}")
    first_block = template.root.nodelist.first
    
    assert_equal 'http://api.flickr.com/services/feeds/photos_public.gne?id=57966634@N00&format=rss_200', first_block.feed_url
  end
  
  def test_should_use_parameterised_url_for_feed
    template = Liquid::Template.parse("{% flickrphotostream feed: http://blah/test.xml %}<img />{% endflickrphotostream %}")
    first_block = template.root.nodelist.first
    
    assert_equal 'http://blah/test.xml', first_block.feed_url
  end
  
  def test_should_use_parameterised_number_of_items
    template = Liquid::Template.parse("{% flickrphotostream count: 2 %}<img />{% endflickrphotostream %}")
    first_block = template.root.nodelist.first
    
    assert_equal 2, first_block.count
  end
  
  def test_should_parse_two_parameters_correctly
    template = Liquid::Template.parse("{% flickrphotostream feed: http://blah/test.xml count: 2 %}<img />{% endflickrphotostream %}")
    first_block = template.root.nodelist.first
    
    assert_equal 'http://blah/test.xml', first_block.feed_url
    assert_equal 2, first_block.count
  end
  
  def test_should_pass_parameters_to_flickr_aggregator
    template = Liquid::Template.parse("{% flickrphotostream feed: http://blah/test-another.xml count: 2 %}<img />{% endflickrphotostream %}")
    first_block = template.root.nodelist.first
    
    template.render
    
    assert_equal 2, FlickrPictureProvider.number_of_items_chosen
    assert_equal 'http://blah/test-another.xml', FlickrPictureProvider.feed_url
  end
  
  def test_should_use_six_items_by_default
    template = Liquid::Template.parse("{% flickrphotostream %}<img />{% endflickrphotostream %}")
    first_block = template.root.nodelist.first
        
    assert_equal 6, first_block.count
  end
  
  protected
    PICTURE_ATTRS = {
      :title => 'test',
      :description => 'http://static.flickr.com/photos/my_image_m.jpg',
      :link => '/photos/pingles/test'
      }
  
    def create_picture(args = {})
      FlickrAggregation::Picture.new(args.reverse_merge(PICTURE_ATTRS))      
    end
  
    def render(template_content)
      output = render_template(template_content)
      root_node = HTML::Document.new(output).root
    end
    
    def render_template(template_content)
      output = Liquid::Template.parse(template_content).render
    end    
end

class FlickrPictureProvider
  def initialize(attrs = {})
    @@feed_url = attrs[:feed]
  end
  
  def self.stub_pics=(pics)
    @@pics = pics
  end
    
  def choose(number)
    @@number = number
    @@pics
  end
  
  def self.number_of_items_chosen
    @@number ||= 0
  end
  
  def self.feed_url
    @@feed_url ||= ''
  end
end