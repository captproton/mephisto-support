class FlickrPictureProvider
  def initialize(attrs = {})
    @attrs = attrs
  end
  
  def choose(count)
    FlickrAggregation.new(@attrs[:feed]).choose(@attrs[:count].to_i)
  end
end