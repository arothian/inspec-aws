
# TaggableBase
RSpec::Matchers.define :have_tag do |tag_key|
  match do |subject|
    subject.has_tag?(tag_key, @value)
  end

  chain :with_value do |value|
    @value = value
  end
end

# SecutiryGroup
RSpec::Matchers.define :have_ingress_rule do |hash|
  match do |subject|
    hash = {} if hash.nil?
    hash[:source] = @source unless @source.nil?
    subject.has_ingress_rule?(hash)
  end

  chain :with_source do |value|
    @source = value
  end
end
RSpec::Matchers.define :have_egress_rule do |hash|
  match do |subject|
    hash = {} if hash.nil?
    hash[:source] = @source unless @source.nil?
    subject.has_egress_rule?(hash)
  end
  
  chain :with_source do |value|
    @source = value
  end
end
