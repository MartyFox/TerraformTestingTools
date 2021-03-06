# route53-zones

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)

## Overview

A module that creates one or more route53 zones

## Usage

```hcl
module "route53-zones" {
  source = "git::ssh://"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| null | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| null | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| mandatory | this field is mandatory | `string` | n/a | yes |
| optional | this field is optional | `string` | `"default_value"` | no |

## Outputs

| Name | Description |
|------|-------------|
| output\_name | description for output\_name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```


- Configure golang deps for tests
```sh
> go get github.com/gruntwork-io/terratest/modules/terraform
> go get github.com/stretchr/testify/assert
```



### Tests

- Tests are available in `test` directory

- In the test directory, run the below command
```sh
go test
```



## Authors

This project is authored by below people

- MFox

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
