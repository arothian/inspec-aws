require 'spec_helper'

ec2_client = Aws::EC2::Client.new(region: 'us-west-2', stub_responses: true)
ec2_resource = Aws::EC2::Resource.new(client: ec2_client)
# stub a dummy Subnet response
ec2_client.stub_responses(:describe_subnets, subnets: [
  {
    subnet_id: 'subnet-id',
    state: 'available',
    vpc_id: 'vpc-id',
    cidr_block: '10.0.0.0/24',
    available_ip_address_count: 48,
    availability_zone: 'us-west-2b',
    default_for_az: true,
    map_public_ip_on_launch: false,
    tags: [
      {
        key: 'Name',
        value: 'Test-Subnet'
      }
    ]
  }
])

describe aws_vpc = Subnet.new(id: 'subnet-id', ec2_resource: ec2_resource) do
  its(:id) { should eq 'subnet-id' }
  its(:vpc_id) { should eq 'vpc-id'}
  its(:cidr_block) { should eq '10.0.0.0/24' }
  its(:availability_zone) { should eq 'us-west-2b' }
  its(:available_ip_address_count) { should > 10 }
  its(:state) { should eq 'available' }
  it { should be_default_for_az }
  it { should_not be_map_public_ip_on_launch }
  it { should have_tag('Name').with_value('Test-Subnet') }
  it { should_not have_tag('Bob') }
end
