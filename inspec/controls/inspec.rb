title "Testing Terraform AWS Resources"

# load data from Terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

# store vpc in variable
VPC_ID = params['vpc_id']['value']
SG_ID = params['sg_id']['value']
# you can use the variable in various spaces

describe aws_vpc(vpc_id: VPC_ID) do
  its('cidr_block') { should cmp '172.31.0.0/16' }
end

describe aws_ec2_instance(name: 'test-testing-instance') do
  it { should exist }
  it { should be_running }
  its('image_id') { should cmp 'ami-0978f2d57755c6503' }
  its('security_groups') { should include(id: SG_ID, name: 'test-testing-security-group') }
  its('tags') { should include(key: 'Name', value: 'test-testing-instance') }
  its('tags_hash') { should include('Environment') }
  its('tags_hash') { should include('Project') }
end

describe aws_security_group(group_name: 'test-testing-security-group') do
  it { should exist }
  its('group_name') { should eq 'test-testing-security-group' }
  its('description') { should cmp 'A Sec Group for my testing instance' }
  its('inbound_rules.count') { should cmp 1 }
  its('vpc_id') { should eq VPC_ID }  
  it { should allow_in(port: 8080, protocol: 'tcp', ipv4_range: '172.31.0.0/16') }
  its('tags') { should include(key: 'Name', value: 'test-testing-security-group') }
  its('tags_hash') { should include('Environment') }
  its('tags_hash') { should include('Project') }
end