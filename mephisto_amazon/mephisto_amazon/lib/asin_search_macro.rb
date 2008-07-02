require 'mephistoamazon/keyword_search'
require 'mephistoamazon/search_delegate'

class AsinSearchMacro < FilteredColumn::Macros::Base
  def self.filter(attributes, inner_text='', text='')
    @view = MephistoAmazon::Product_View
    @delegate = MephistoAmazon::SearchDelegate.new       
    amazon_product = @delegate.asin_search(inner_text)

    unless amazon_product == nil?
     template = Liquid::Template.parse( File.read(MephistoAmazon::Product_View ) )
     template.render( {'product' => amazon_product} )
    else
      template = Liquid::Template.parse( File.read( MephistoAmazon::Error_View ) )  
      template.render( {'msg' => "No matching product"} )
    end
  end
end
