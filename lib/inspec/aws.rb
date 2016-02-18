require 'aws-sdk'
require 'inspec'

require_relative 'aws/version'

require_relative 'aws/resources/ec2_base'
require_relative 'aws/resources/taggable_base'
require_relative 'aws/resources/vpc'
require_relative 'aws/resources/subnet'
require_relative 'aws/resources/security_group'
require_relative 'aws/resources/instance'
require_relative 'aws/matcher/matchers'
