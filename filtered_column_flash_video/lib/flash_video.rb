class FlashVideo < FilteredColumn::Macros::Base
  DEFAULT_OPTIONS = {:width => 400, :height => 400}
  def self.filter(attributes, inner_text = '', text = '')
    options = DEFAULT_OPTIONS.dup
    options[:width] = attributes[:width].to_i unless attributes[:width].blank?
    options[:height] = attributes[:height].to_i unless attributes[:height].blank?
    random_seed = rand(50000000000)
    begin
      return <<HHHHHTML
<embed src="/flash_player/flvplayer.swf" 
    width="#{options[:width]}" 
    height="#{options[:height]}" 
    type="application/x-shockwave-flash" 
    pluginspage="http://www.macromedia.com/go/getflashplayer"
    flashvars="file=#{inner_text}&displayheight=#{options[:height]}&displaywidth=#{options[:width]}" 
/>
HHHHHTML
    rescue
      RAILS_DEFAULT_LOGGER.warn "Flash Video Error: #{$!.message}"
      RAILS_DEFAULT_LOGGER.debug $!.backtrace.join("\n")
      return "<!-- Flash Video Failed to Load -->"
    end
  end
end

