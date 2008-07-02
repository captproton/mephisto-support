
module MephistoAmazon
  class ResponseDrop < Liquid::Drop
    
    def initialize response
      @resp = response
    end
  
    def asin
      @resp.asin
    end
  
    def authors
      @resp.authors
    end
  
    def availability
      @resp.availability
    end
    
    def average_customer_rating
      @resp.average_customer_rating
    end
    
    def browse_list
      @resp.browse_list
    end
    
    def catalog
      @resp.catalog
    end
    
    def collectible_price
      @resp.collectible_price
    end
  
    def features
      @resp.features
    end

    def name
      @resp.product_name
    end
  
    def isbn
      @resp.isbn
    end
  
    def list_price
      @resp.list_price
    end

    def lists
      @resp.lists
    end
    
    def manufacturer
      @resp.manufactuer
    end
    
    def media
      @resp.media
    end
    
    def our_price
      @resp.our_price
    end
    
    def image_url_large
      @resp.image_url_large
    end

    def image_url_medium
      @resp.image_url_medium
    end

    def image_url_small
      @resp.image_url_small
    end
    
    def release_date
      @resp.release_date
    end
    
    def underlying
      @resp.to_s
    end
  end
end