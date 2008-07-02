require 'mephistoamazon/keyword_search'
require 'mephistoamazon/search_delegate'

class WishlistSearchMacro < FilteredColumn::Macros::Base
  def self.filter(attributes, inner_text='', text='')
    @view = MephistoAmazon::Products_View
    @delegate = MephistoAmazon::SearchDelegate.new    
    args = inner_text.scan(/\w+/)
    
    amazon_products = @delegate.wishlist_search(inner_text)

    unless amazon_products == nil?
     template = Liquid::Template.parse( File.read( MephistoAmazon::Products_View ) )
     template.render( {'products' => amazon_products} )
    else
      template = Liquid::Template.parse( File.read( MephistoAmazon::Error_View ) )  
      template.render( {'msg' => "No matching wishlist for #{inner text}!"} )
    end
  end
end
