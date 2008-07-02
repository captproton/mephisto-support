require File.dirname(__FILE__) + '/../test_helper'
require 'ostruct'

class MephistoArticleImageFetchyTest < Test::Unit::TestCase
  def test_find_images_in_doc
    Asset.any_instance.expects(:public_filename).times(1).returns("/fake/url")
    Article.any_instance.expects(:site).returns(stub(:assets => stub(:build => stub(:save! => nil, :public_filename => Asset.new.public_filename))))
    
    a = Article.new(:body => 'this is an <img src="http://FAKEURL" /><img src="http://BAD" /> image')
    a.body_html = a.body
    def a.open(url)
      raise StandardError if url =~ /BAD/
      yield OpenStruct.new(:content_type => 'image/jpeg', :read => 'foo')
    end
    a.send(:store_remote_images_as_assets)

    assert_equal "this is an <img src=\"/fake/url\" /><img src=\"http://BAD\" /> image", a.body_html
  end
end
