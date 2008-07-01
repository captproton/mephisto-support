require 'open_flash_chart'

class FlashChart < FilteredColumn::Macros::Base
  DEFAULT_OPTIONS = {:height => '300', :width => '450'}
  def self.filter(attributes, inner_text = '', text = '')
    begin
      # Pass in the url in the inner_text
      raise "No Url Given" if inner_text.blank?

      options = DEFAULT_OPTIONS.dup
      options[:width] = attributes[:width] unless attributes[:width].blank?
      options[:height] = attributes[:height] unless attributes[:height].blank?
      return OpenFlashChart.swf_object(options[:width], options[:height], inner_text)
    rescue
      RAILS_DEFAULT_LOGGER.warn "Flash Chart Error: #{$!.message}"
      RAILS_DEFAULT_LOGGER.debug $!.backtrace.join("\n")
      return "<!-- Flash Chart Failed to Load -->"
    end
  end
end
