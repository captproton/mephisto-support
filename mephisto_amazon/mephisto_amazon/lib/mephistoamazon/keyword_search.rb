module MephistoAmazon
  class KeywordSearch < Liquid::Block

    attr_writer :delegate, :view
    attr_reader :delegate
    
    def initialize(tag_name, markup, tokens)
      super
      @markup = markup
      @tokens = tokens
      @view = Products_View
      @delegate = MephistoAmazon::SearchDelegate.new

      args = markup.scan(/\w+/)
   
      @mode =  args[0].downcase
      @keywords = markup[@mode.length..-1].strip
    end    
    
    def rlogger() RAILS_DEFAULT_LOGGER end
    
    def render(context) 
      amazon_products = @delegate.search(@mode, @keywords)
    
     #breakpoint
      unless amazon_products == nil?
       template = Liquid::Template.parse( File.read( @view ) )
       template.render( {'products' => amazon_products} )
      else
        template = Liquid::Template.parse( File.read( Error_Template ) )  
        template.render( {'msg' => "No matching product(s)!"} )
      end
     
    end
  end
end
Liquid::Template.register_tag('keyword_search', MephistoAmazon::KeywordSearch)