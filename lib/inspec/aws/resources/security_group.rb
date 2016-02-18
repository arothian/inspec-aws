# author: Kevin Formsma

# Usage:
#
# describe aws_security_group('sg-123456') do
#   its(:group_id) { should eq 'sg-123456' }
#   its(:description) { should eq 'Cool SG' }
#   its(:group_name) { should eq 'SG1 }
#   its(:owner_id) { should eq '123456789' }
#   its(:vpc_id) { should eq 'vpc-123456' }
#   it { should have_tag('Name').with_value('SG1') }
#   it { should have_ingress_rule(ip_protocol: 'tcp', from_port: 22).with_source('0.0.0.0/32') }
#   it { should have_egress_rule(ip_protocol: 'tcp').with_source('sg-123457') }
# end

class SecurityGroup < TaggableBase
  name 'aws_security_group'
  desc 'Use the aws-security-group resource to test AWS EC2 Security Groups.'
  example "
    describe aws_security_group('sg-123456') do
      its(:group_id) { should eq 'sg-123456' }
      its(:description) { should eq 'Cool SG' }
      its(:group_name) { should eq 'SG1 }
      its(:owner_id) { should eq '123456789' }
      its(:vpc_id) { should eq 'vpc-123456' }
      it { should have_tag('Name').with_value('SG1') }
      it { should have_ingress_rule(ip_protocol: 'tcp', from_port: 22).with_source('0.0.0.0/32') }
      it { should have_egress_rule(ip_protocol: 'tcp').with_source('sg-123457') }
    end
  "

  def get_ec2_resource(id:)
    @ec2_resource.security_group(id)
  end

  def has_ingress_rule?(ip_protocol: nil, from_port: nil, to_port: nil, source: nil)
    has_rule?(rules: @resource.ip_permissions, ip_protocol: ip_protocol, from_port: from_port, to_port: to_port, source: source)
  end

  def has_egress_rule?(ip_protocol: nil, from_port: nil, to_port: nil, source: nil)
    has_rule?(rules: @resource.ip_permissions_egress, ip_protocol: ip_protocol, from_port: from_port, to_port: to_port, source: source)
  end

  def to_s
    "Security Group #{@resource.group_id}"
  end

  private
  def has_rule?(rules:, ip_protocol:, from_port:, to_port:, source:)
    rules = rules.select do |rule|
      valid_protocol = rule.ip_protocol == ip_protocol || ip_protocol.nil?
      valid_port = (rule.from_port == from_port || from_port.nil?) && (rule.to_port == to_port || to_port.nil?)
      valid_protocol && valid_port
    end

    rules.size > 0 && (source.nil? || has_source?(rules: rules, source: source))
  end

  def has_source?(rules:, source:)
    found = false
    rules.each do |rule|
      found = !rule.ip_ranges.find_index { |cidr| cidr.cidr_ip == source }.nil?
      found = !rule.user_id_group_pairs.find_index { |group| group.group_id == source }.nil? unless found
      found = !rule.prefix_list_ids.find_index { |prefix| prefix.prefix_list_id == source }.nil? unless found
      break if found
    end
    found
  end
end
