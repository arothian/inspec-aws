# author: Kevin Formsma

class TaggableBase < EC2Base
  def has_tag?(tag_key = nil, value = nil)
    tags = @resource.tags
    puts tags.size
    return tags.size > 0 if tag_key.nil?
    tags.each do |tag|
      if tag.key == tag_key
        return value.nil? || tag.value == value
      end
    end
    false
  end
end
