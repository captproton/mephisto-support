module MephistoAmazon
  class AsinSearch < Liquid::Block

    attr_writer :delegate, :view
    attr_reader :delegate
    
    def initialize(tag_name, markup, tokens)
      super
      @markup = markup
      @tokens = tokens
      @view = Product_View
      @delegate = MephistoAmazon::SearchDelegate.new

      args = markup.scan(/\w+/)
    end    
    
    def rlogger() RAILS_DEFAULT_LOGGER end
    
    def render(context) 
      amazon_product = @delegate.asin_search(@markup)
     
      unless amazon_product == nil?
       template = Liquid::Template.parse( File.read( @view ) )
       template.render( {'product' => amazon_product} )
      else
        template = Liquid::Template.parse( File.read( Error_Template ) )  
        template.render( {'msg' => "No matching product!"} )
      end
     
    end
  end
end
Liquid::Template.register_tag('asin_search', MephistoAmazon::AsinSearch)