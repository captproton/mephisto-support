module MephistoPlugins
  module TagCloud
    def size_tag(tag, largest = 2, smallest = 0.5)
      number = ActiveRecord::Base.count_by_sql(
        ["SELECT COUNT(*) FROM taggings, 
            tags, contents WHERE 
            tags.name = ? AND taggings.tag_id = tags.id
            AND contents.id = taggings.taggable_id
            AND contents.published_at IS NOT NULL;", tag])
      size = sprintf("%0.2f", number.to_f / 5)
      size = size.to_f > largest ? largest : size.to_f < smallest ? smallest : size
      "<span style='font-size: #{size}em'><a title='#{tag}' href='/tags/#{tag}'>#{tag}</a></span>"
    end
  end
end
