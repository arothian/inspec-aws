# author: Kevin Formsma

# Usage:
#
# describe aws_vpc('vpc-id') do
#   its(:id) { should eq 'vpc-id' }
#   its(:cidr_block) { should eq '10.0.0.0/16' }
#   its(:dhcp_options_id) { should eq '' }
#   its(:state) { should eq 'available' }
#   its(:instance_tenancy) { should eq 'default' }
#   it { should be_default }
#   it { should have_tag('Name').with_value('VPC Name') }
# end

class Vpc < TaggableBase
  name 'aws_vpc'
  desc 'Use the aws-vpc resource to test AWS EC2 VPCs.'
  example "
    describe aws_vpc('vpc-123456') do
      its(:id) { should eq 'vpc-123456' }
      its(:cidr_block) { should eq '10.0.0.0/16' }
      its(:dhcp_options_id) { should eq 'dopt-00000000' }
      its(:state) { should eq 'available' }
      its(:instance_tenancy) { should eq 'default' }
      it { should be_default }
      it { should have_tag('Name').with_value('VPC Name') }
    end
  "

  def get_ec2_resource(id:)
    @ec2_resource.vpc(id)
  end

  def default?
    @resource.is_default
  end

  def instances
    @resource.instances.map { |instance| Instance.new(resource: instance, ec2_resource: @ec2_resource) }
  end

  def subnets
    @resource.subnets.map { |subnet| Subnet.new(resource: subnet, ec2_resource: @ec2_resource) }
  end

  def security_groups
    @resource.security_groups.map { |sec_grp| SecurityGroup.new(resource: sec_grp, ec2_resource: @ec2_resource) }
  end

  def to_s
    "Vpc #{@resource.id}"
  end
end
