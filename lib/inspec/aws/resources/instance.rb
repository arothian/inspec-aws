# author: Kevin Formsma

class Instance < TaggableBase
  name 'aws_instance'
  desc 'Use the aws-instance resource to test AWS EC2 Instances.'
  example "
    describe aws-instance(id: 'i-123456') do
      it { should have_tag('Name').with_value('VPC Name') }
    end
  "
  
  def get_ec2_resource(id:)
    @ec2_resource.instance(id)
  end
  
  # TODO: block_device_mappings / volumes
  # TODO: iam_instance_profile
  # TODO: placement eg AZ
  # TODO: image
  # TODO: network interfaces

  def security_groups
    @resource.security_groups.map { |sg| SecurityGroup.new(id: sg.group_id, ec2_resource: @ec2_resource) }
  end

  def subnet
    Subnet.new(resource: @resource.subnet, ec2_resource: @ec2_resource)
  end

  def vpc
    Vpc.new(resource: @resource.vpc, ec2_resource: @ec2_resource)
  end

  def to_s
    "Instance #{@resource.id}"
  end
end
