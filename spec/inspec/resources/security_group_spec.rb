require 'spec_helper'

ec2_client = Aws::EC2::Client.new(region: 'us-west-2', stub_responses: true)
ec2_resource = Aws::EC2::Resource.new(client: ec2_client)
# stub a dummy Subnet response
ec2_client.stub_responses(:describe_security_groups, security_groups: [
  {
    owner_id: '000000000000000000000',
    group_name: 'sg-group',
    group_id: 'sg-id',
    description: 'sg-group description',
    ip_permissions: [
      {
        ip_protocol: 'tcp',
        from_port: 22,
        to_port: 22,
        user_id_group_pairs: [
          {
            user_id: '000000000000000000000',
            group_name: nil,
            group_id: 'sg-ddccbbaa'
          }
        ],
        ip_ranges: [
          {
            cidr_ip: '10.0.0.0/16'
          }
        ],
        prefix_list_ids: []
      },
      {
        ip_protocol: 'tcp',
        from_port: 80,
        to_port: 80,
        user_id_group_pairs: [],
        ip_ranges: [
          {
            cidr_ip: '10.1.0.0/16'
          }
        ],
        prefix_list_ids: []
      }
    ],
    ip_permissions_egress: [
      {
        ip_protocol: '-1',
        from_port: nil,
        to_port: nil,
        user_id_group_pairs: [],
        ip_ranges: [
          {
            cidr_ip: '0.0.0.0/0'
          }
        ],
        prefix_list_ids: [
          {
            prefix_list_id: 'pl-id'
          }
        ]
      }
    ],
    vpc_id: 'vpc-id',
    tags: [
      {
        key: 'Name',
        value: 'SG-Name'
      }
    ]
  }
])

describe aws_vpc = SecurityGroup.new(id: 'sg-id', ec2_resource: ec2_resource) do
  its(:group_id) { should eq 'sg-id' }
  its(:description) { should eq 'sg-group description' }
  its(:group_name) { should eq 'sg-group' }
  its(:owner_id) { should eq '000000000000000000000' }
  its(:vpc_id) { should eq 'vpc-id' }

  it { should have_tag('Name').with_value('SG-Name') }
  it { should_not have_tag('Bob') }

  it { should have_ingress_rule() }
  it { should have_ingress_rule(ip_protocol: 'tcp', from_port: 22, to_port: 22) }
  it { should have_ingress_rule(ip_protocol: 'tcp') }
  it { should have_ingress_rule(from_port: 22) }
  it { should have_ingress_rule(to_port: 22) }
  it { should have_ingress_rule(ip_protocol: 'tcp', from_port: 22, to_port: 22).with_source('sg-ddccbbaa') }
  it { should have_ingress_rule(from_port: 22, to_port: 22).with_source('10.0.0.0/16') }
  it { should have_ingress_rule().with_source('10.1.0.0/16') }
  it { should_not have_ingress_rule().with_source('0.0.0.0/0') }
  it { should_not have_ingress_rule(ip_protocol: 'tcp', from_port: 443, to_port: 443) }

  it { should have_egress_rule(ip_protocol: '-1').with_source('0.0.0.0/0') }
  it { should have_egress_rule(ip_protocol: '-1').with_source('pl-id') }
end
