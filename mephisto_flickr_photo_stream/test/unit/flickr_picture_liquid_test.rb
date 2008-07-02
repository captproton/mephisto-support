require 'test/unit'
require File.dirname(__FILE__) + '/../../../../../test/test_helper'
require File.dirname(__FILE__) + '/../mocks/flickr_aggregation'

class FlickrPictureLiquidTest < Test::Unit::TestCase
  
  def test_should_generate_correct_address_for_each_image_size
    pic = FlickrAggregation::Picture.new(:title => 'test', :description => <<-EOS
    <p><a href="http://www.flickr.com/people/pingles/">Paul Ingles</a> posted a photo:</p> +
    <p>
      <a href="http://www.flickr.com/photos/pingles/289807638/" title="Me in Hyde Park">
        <img src="http://farm1.static.flickr.com/my_image_m.jpg" width="180" height="240" alt="Me in Hyde Park" style="border: 1px solid #ddd;" />
      </a>
    </p>
    <p>Out back of Moon Beach on our third trip there to check out the scene.</p>
    EOS
    )

    assert_equal 'http://farm1.static.flickr.com/my_image_m.jpg', pic.image
    assert_equal 'http://farm1.static.flickr.com/my_image_d.jpg', pic.medium
    assert_equal 'http://farm1.static.flickr.com/my_image_t.jpg', pic.thumb
    assert_equal 'http://farm1.static.flickr.com/my_image_s.jpg', pic.square
  end
  
  def test_should_work_with_escaped_description
    pic = FlickrAggregation::Picture.new(:title => 'test', :description => <<-EOS
    <p>
      <a href="http://www.flickr.com/photos/pingles/366224362/" title="Oh No, The Tea!"><img src="http://farm1.static.flickr.com/147/366224362_da28d87056_m.jpg" width="177" height="240" alt="Oh No, The Tea!" style="border: 1px solid #ddd;" /></a>
    </p>
    EOS
    )
    
    assert_equal 'http://farm1.static.flickr.com/147/366224362_da28d87056_s.jpg', pic.square
  end
  
  def test_should_be_give_a_liquid_drop_from_picture
    assert_kind_of PictureDrop, FlickrPictureProvider.new(:feed => 'http://my-test/url').choose(1).first.to_liquid
  end
  
  def test_picture_view_object_correctly_maps_all_attributes
    pic = FlickrAggregation::Picture.new(:title => 'test', :description => 'http://static.flickr.com/my_image_m.jpg')
    drop = pic.to_liquid
    
    assert_equal pic.title, drop.title
    assert_equal pic.image, drop.image
    assert_equal pic.square, drop.square
    assert_equal pic.thumb, drop.thumb
    assert_equal pic.link, drop.link
    assert_equal pic.medium, drop.medium
  end
end