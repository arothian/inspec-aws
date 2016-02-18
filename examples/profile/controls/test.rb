
control 'sg-1' do
  impact 1.0
  title 'Security Group: No ingress access to CIDR block 0.0.0.0/0'
  desc 'Security Groups must not allow inbound access from anywhere'
  
  Vpc.new(id: ENV['vpc_id']).security_groups.each do |security_group|
    describe security_group do
      it { should_not have_ingress_rule().with_source('0.0.0.0/0') }
    end
  end
end
