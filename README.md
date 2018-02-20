# Notice
Inspec now features resources for cloud providers directly. Check it out at https://www.inspec.io/docs/reference/platforms/

# Inspec::Aws

This gem is a collection of custom [inspec](https://github.com/chef/inspec) resources targeting AWS resources.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'inspec-aws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inspec-aws

## Usage

Take a look at the examples Inspec profile at `examples/profile`. You can run `examples/bin/demo_noncompliant_vpc.rb` which will launch a CloudFormation stack in us-west-2, run the inspec profile against it, and then delete the stack. The script assumes you have AWS cli credentials already setup.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arothian/inspec-aws.
