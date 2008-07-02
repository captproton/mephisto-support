require 'tempfile'

module MephistoAmazon
  class SearchDelegate
      
    attr_writer :request
    
    def initialize
      dev_token = MephistoPlugin[:amazon].amazon_dev_token
      ass_id = MephistoPlugin[:amazon].amazon_associate_id 
      @request = Amazon::Search::Request.new(dev_token, ass_id)
      cache = Tempfile.new "mephisto_amazon"
      @request.cache = Amazon::Search::Cache.new("#{cache.path}1")
    end
    
     def rlogger() RAILS_DEFAULT_LOGGER end
    
    def search(mode, keywords)
      #rlogger.info("mode = #{mode}, keywords = #{keywords}")
      response = @request.keyword_search(keywords, mode)
    
      unless response == nil?         
        drops = to_drops response  
      end
      
      drops
    end

    def asin_search(asin)
      response = @request.asin_search(asin)
      
      unless response == nil?
        drop = to_drop response
      end
        
      drop
    end
    
    def wishlist_search(wishlist_id)
      response = @request.wishlist_search(wishlist_id, Amazon::Search::HEAVY)
    
      unless response == nil?         
        drops = to_drops response  
      end
      
      drops 
    end

    def to_drops response
      drops = []
      response.products.each {|resp| drops << MephistoAmazon::ResponseDrop.new(resp)}  
      drops
    end

    def to_drop response
      MephistoAmazon::ResponseDrop.new(response.products[0])
    end
  end
end

