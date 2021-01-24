package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Tests for module route53_zones that tests public and private zones
func TestTerraformAwsNetworkExample(t *testing.T) {
	t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	// awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	awsDefaultVpc := aws.GetDefaultVpc(t, awsRegion)

	vpcID := awsDefaultVpc.Id

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../example/",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"public_zones": map[string]interface{}{
				"r53example.org": map[string]interface{}{
					"comment": "r53example.org public zone",
					"tags": map[string]interface{}{
						"Name": "r53example.org",
					},
				},
			},
			"private_zones": map[string]interface{}{
				"r53example.aws.local": map[string]interface{}{
					"comment": "r53example private zone",
					"vpc":     vpcID,
					"tags": map[string]interface{}{
						"Name": "r53example.aws.local",
					},
				},
			},
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	publicZoneIds := terraform.Output(t, terraformOptions, "public_zones_zoneids")
	publicNameServers := terraform.Output(t, terraformOptions, "public_zones_nameservers")

	privateZoneIds := terraform.Output(t, terraformOptions, "private_zones_zoneids")
	privateNameServers := terraform.Output(t, terraformOptions, "private_zones_nameservers")

	// check outputs are not empty
	assert.NotEmpty(t, publicZoneIds)
	assert.NotEmpty(t, publicNameServers)
	assert.NotEmpty(t, privateZoneIds)
	assert.NotEmpty(t, privateNameServers)

	// Check nameservers contain correct Zone name
	assert.Containsf(t, publicNameServers, "r53example.org", "error message %s", "formatted")
	assert.Containsf(t, privateNameServers, "r53example.aws.local", "error message %s", "formatted")

}
