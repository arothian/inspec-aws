# author: Kevin Formsma

# Usage:
#
# describe aws_subnet(subnet_id: 'subnet-12345678') do
#   its(:id) { should eq 'subnet-12345678' }
#   its(:vpc_id) { should eq 'vpc-12345678'}
#   its(:cidr_block) { should eq '10.0.0.0/24' }
#   its(:availability_zone) { should eq 'us-west-2b' }
#   its(:available_ip_address_count) { should > 10 }
#   its(:state) { should eq 'available' }
#   its(:instance_tenancy) { should eq 'default' }
#   it { should be_default_for_az }
#   it { should be_map_public_ip_on_launch }
#   it { should have_tag('Name').with_value('VPC Name') }
# end

class Subnet < TaggableBase
  name 'aws_subnet'
  desc 'Use the aws-subnet resource to test AWS EC2 Subnets.'
  example "
    describe aws_subnet(subnet_id: 'subnet-12345678') do
      its(:id) { should eq 'subnet-12345678' }
      its(:vpc_id) { should eq 'vpc-12345678'}
      its(:cidr_block) { should eq '10.0.0.0/24' }
      its(:availability_zone) { should eq 'us-west-2b' }
      its(:available_ip_address_count) { should > 10 }
      its(:state) { should eq 'available' }
      its(:instance_tenancy) { should eq 'default' }
      it { should be_default_for_az }
      it { should be_map_public_ip_on_launch }
      it { should have_tag('Name').with_value('VPC Name') }
    end
  "

  def get_ec2_resource(id:)
    @ec2_resource.subnet(id)
  end
  
  def instances
    @resource.instances.map { |instance| Instance.new(resource: instance, ec2_resource: @ec2_resource) }
  end
  
  def vpc
    Vpc.new(resource: @resource.vpc, ec2_resource: @ec2_resource)
  end

  def default_for_az?
    @resource.default_for_az
  end

  def map_public_ip_on_launch?
    @resource.map_public_ip_on_launch
  end

  def to_s
    "Subnet #{@resource.id}"
  end
end
