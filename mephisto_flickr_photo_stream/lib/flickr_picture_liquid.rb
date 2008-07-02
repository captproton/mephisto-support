class PictureDrop < BaseDrop
  def initialize(picture)
    super picture
    @picture = picture
  end
  
  def image
    @picture.image
  end
  
  def title
    @picture.title
  end
  
  def square
    @picture.square
  end
  
  def thumb
    @picture.thumb
  end
  
  def link
    @picture.link
  end
  
  def medium
    @picture.medium
  end
end

module FlickrPhotoStream::Picture
  def to_liquid
    PictureDrop.new self
  end
end

FlickrAggregation::Picture.send :include, FlickrPhotoStream::Picture