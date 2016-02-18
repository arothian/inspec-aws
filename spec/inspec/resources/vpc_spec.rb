require 'spec_helper'

ec2_client = Aws::EC2::Client.new(region: 'us-west-2', stub_responses: true)
ec2_resource = Aws::EC2::Resource.new(client: ec2_client)
# stub a dummy VPC response
ec2_client.stub_responses(:describe_vpcs, vpcs: [
  {
    vpc_id: 'vpc-id',
    state: 'available',
    cidr_block: '10.0.0.0/16',
    dhcp_options_id: 'dopt-id',
    tags: [
      {
        key: 'Name',
        value: 'Test-Vpc'
      }
    ],
    instance_tenancy: 'default',
    is_default: false
  }
])

describe aws_vpc = Vpc.new(id:'vpc-id', ec2_resource: ec2_resource) do
  it { is_expected.not_to be_default }

  its(:id) { is_expected.to eq 'vpc-id'}
  its(:cidr_block) { is_expected.to eq '10.0.0.0/16' }
  its(:dhcp_options_id) { is_expected.to eq 'dopt-id' }
  its(:state) { is_expected.to eq 'available' }
  its(:instance_tenancy) { is_expected.to eq 'default' }

  it { is_expected.to have_tag('Name').with_value('Test-Vpc') }
  it { is_expected.to_not have_tag('Bob')}
end
