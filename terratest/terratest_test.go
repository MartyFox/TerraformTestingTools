package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the Terraform module in examples/terraform-aws-network-example using Terratest.
func TestTerraformAwsExample(t *testing.T) {
	t.Parallel()
	assert := assert.New(t)

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	cidrBlocks := []string{"172.31.0.0/16"}
	amiID := aws.GetAmazonLinuxAmi(t, awsRegion)
	instanceName := "terratest_instance"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../.",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region":        awsRegion,
			"ami_id":        amiID,
			"instance_name": instanceName,
			"instance_size": "t3.micro",
			"cidr_blocks":   cidrBlocks,
			"port":          8080,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	sgID := terraform.Output(t, terraformOptions, "sg_id")
	sgTotalIngress := terraform.Output(t, terraformOptions, "sg_total_ingress")
	InstanceID := terraform.Output(t, terraformOptions, "instance_id")

	// Look up the values from AWS
	instanceIP := aws.GetPrivateIpOfEc2Instance(t, InstanceID, awsRegion)
	instanceHostname := aws.GetPrivateHostnameOfEc2Instance(t, InstanceID, awsRegion)
	instanceTags := aws.GetTagsForEc2Instance(t, awsRegion, InstanceID)
	defaultVPC := aws.GetDefaultVpc(t, awsRegion)

	// run tests on outputs
	assert.Contains(defaultVPC.Id, vpcID)
	assert.Contains(instanceIP, "172.31")
	assert.Contains(instanceHostname, awsRegion)
	assert.Contains(instanceTags["Name"], instanceName)
	assert.NotEmptyf(sgID, "error message %s", "formatted")
	assert.Equal(sgTotalIngress, "1", "Total rules equals 1")
}
