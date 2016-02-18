#!/usr/bin/env ruby

require 'cfndsl'
require 'aws-sdk'
require 'inspec'
require 'inspec/aws'

ENV['AWS_REGION'] = 'us-west-2'

examples_home = File.dirname(__FILE__)+'/..'

#Create a new VPC with some failures
template_body = CfnDsl::eval_file_with_extras("#{examples_home}/noncompliant_vpc_cfndsl.rb",[],false).to_json

cfn_client = Aws::CloudFormation::Client.new
cfn_resource = Aws::CloudFormation::Resource.new(client: cfn_client)

cfn_client.validate_template(template_body: template_body)

stack_name = "InspecAwsDemo-NonCompliant-#{Time.now.utc.strftime('%Y%m%d%H%M%S')}"

puts "Launching CFN stack #{stack_name} in #{ENV['AWS_REGION']}"
stack = cfn_resource.create_stack(
  stack_name: stack_name,
  template_body: template_body,
  timeout_in_minutes: 5,
  on_failure: 'DELETE'
)

puts 'Waiting for stack to come up...'
cfn_client.wait_until(:stack_create_complete, stack_name: stack_name) do |waiter|
  waiter.delay = 10
  waiter.max_attempts = 30
end
stack.load
vpc_id = stack.outputs.first.output_value
puts "Stack created - vpc-id[#{vpc_id}]"

#Set the VPC ID into the environment
ENV['vpc_id'] = vpc_id

#Run the profile through inspec
begin
  puts "Running Inspec on example profile..."
  o = {}
  o[:logger] = Logger.new(STDOUT)
  o[:logger].level = 'info'

  runner = Inspec::Runner.new(o)
  runner.add_tests(["#{examples_home}/profile"])
  runner.run
ensure
  puts "Deleting stack #{stack_name}"
  stack.delete
end
