CloudFormation {
  Description 'Inspec-aws demo'
  
  VPC('vpc') {
    EnableDnsSupport true
    EnableDnsHostnames true
    CidrBlock '10.1.0.0/16'
    addTag('Name', 'Inspec DEMO VPC')
  }
  
  Resource('AllowSSHFromEveryoneSecurityGroup' ) {
    Type 'AWS::EC2::SecurityGroup'
    Property('VpcId', Ref('vpc'))
    Property('GroupDescription' , 'Enable SSH access and HTTP access on the inbound port')
    Property('SecurityGroupIngress', [ {
        'IpProtocol' => 'tcp',
        'FromPort' => '22',
        'ToPort' => '22',
        'CidrIp' => '0.0.0.0/0'
      }
    ])
  }
  
  Output('vpcid') {
    Description 'The VPC id'
    Value Ref('vpc')
  }
}
