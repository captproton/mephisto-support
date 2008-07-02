require 'mephistoamazon/keyword_search'
require 'mephistoamazon/search_delegate'

class KeywordSearchMacro < FilteredColumn::Macros::Base
  def self.filter(attributes, inner_text='', text='')
    @view = MephistoAmazon::Products_View
    @delegate = MephistoAmazon::SearchDelegate.new    
    args = inner_text.scan(/\w+/)
 
    @mode =  args[0].downcase
    @keywords = inner_text[@mode.length..-1].strip
    
    amazon_products = @delegate.search(@mode, @keywords)

    unless amazon_products == nil?
     template = Liquid::Template.parse( File.read( MephistoAmazon::Products_View ) )
     template.render( {'products' => amazon_products} )
    else
      template = Liquid::Template.parse( File.read( MephistoAmazon::Error_View ) )  
      template.render( {'msg' => "No matching product(s)!"} )
    end
  end
end
