# author: Kevin Formsma

class EC2Base < Inspec.resource(1)
  def initialize(id: nil, resource: nil, ec2_resource: nil)
    if ec2_resource.nil?
      @ec2_resource = Aws::EC2::Resource.new
    else
      @ec2_resource = ec2_resource
    end
    @resource = get_ec2_resource(id: id) unless id.nil?
    @resource = resource unless resource.nil?
    begin
      @resource.load
    rescue Aws::EC2::Errors::ServiceError => error
      skip_resource error
    end
  end

  def method_missing(symbol, *args)
    if @resource.respond_to?(symbol)
      @resource.send(symbol)
    else
      super(symbol, args)
    end
  end
  
  private

  def get_ec2_resource(id:)
    fail NotImplementedError, 'EC2 inspec resource must implement #get_ec2_resource'
  end
end
