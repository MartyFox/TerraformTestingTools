# Terraform Testing Tools

This repo contains examples of different Terraform testing tools each of which are using the same base Terraform code to perform tests.

Each tool provides testing at different levels of Terraform so all can be used together or a combination can be used as per your requirements.

All of the tools can be run via CI/CD pipelines as long as you can:

* *Install the tool*

OR 

* *Can run docker commands using the available images or your own custom images*

---
## Tools 

The testing tools and examples included in this repo are:

#### [Terraform-Complaince](https://github.com/eerkunt/terraform-compliance)
  ```
  Terraform-Compliance is a python based tool that makes use of Gherkin syntax for its tests. The tool runs these checks against Terraform plan files (in JSON format) and is designed for negative testing.
  ```
### [Terratest](https://github.com/gruntwork-io/terratest)
  ```
  Terratest is a Golang tool where tests are also written in Golang files. It is designed to build and destroy your code to prove it works and perform tests against the real world environment to ensure everything is how you want it to look.
  ```

### [Inspec](https://github.com/inspec/inspec-aws)
  ```
  Inspec is a Ruby based tool which makes use of Ruby syntax for test files. It is designed to test real world environments and can output tests results for history
  ```

As I've said already, these 3 tools can be used in combination to provide testing and confidence throughout the CI/CD pipeline. 

**Terratest** can be utilised to test your custom Terraform modules, **Terraform-Compliance** can you be used to test the plan output from Terraform which can be included as part of your teams Pull Request process, **Inspec** can be used to test that everything has deployed as expected after the pipelines complete.

---

## Usage

To use the examples in this code you will need to either install the tools using their respective guides or use docker images where available.

* **Terraform-Compliance** is available via pip or docker with versions available for Terraform 0.11, 0.12 and 0.13 [link](https://terraform-compliance.com/pages/installation/)
* **Terratest** uses Golang to run tests so you will need to have Golang installed: [link](https://golang.org/doc/install#install)
* **Inspec** can be installed locally but there is also a docker image available for use [link](https://github.com/inspec/inspec#usage-via-docker)


Once you have the tools installed or available you can run each test as follows:

#### **Terraform-Compliance**

First you will need to set up a function for you Terraform-Complaince docker image (if using docker) and ensure it has the correct version. Different versions of the image have different Terraform versions. I have used Terraform 0.12.29 here

* `function terraform-compliance { docker run --rm -v $(pwd):/target -i -t eerkunt/terraform-compliance:1.3.0 "$@"; }`

Now you must output a plan file from Terraform and convert it to json format

* `terraform plan -out plan.out`
* `terraform show -json plan.out > plan.out.json`


With everything now in place you can run the included example

* `terraform-compliance -f terraform-compliance/ --planfile plan.out.json`

    <sub>NOTE:
    Terraform Compliance is a plan output tester so it will run only against an output file (converted to JSON) and not access anything outside your device so you dod not need AWS credentials or accounts for this test.<sub>

#### **Terratest**

* `go test terratest/terratest_test.go`

    <sub>NOTE:
    You will need to ensure you have configured your AWS credentials for Terratest, it will deploy the resources into your account and destroy them again but be aware of what account you currently have set via your credentials files/profiles/environment variables.<sub>

#### **Inspec**

First run this command to setup the function and load in your local credential file to the container

* `function inspec { docker run -it --rm -v $(pwd):/share -v $HOME/.aws:/root/.aws chef/inspec "$@"; }`

You will need to run a Terraform output if you are using any outputs within your tests:

* `terraform output --json > inspec/files/terraform.json`

Then you can run inspec

* `inspec exec tests -t aws://<region>/<your profile name> --chef-license=accept`

    <sub>NOTE:
    Note you will need to ensure you have configured your AWS credentials file correctly for Inspec, it will access your account to run the checks so ensure you have setup your credentials correctly for the correct account.<sub>
