# Terraflops Terraform Module
 
### Module name

Creates the required IAM role and policies to allow Sumologic access to read S3 Buckets.

#### Example usage

```hcl-terraform
module "iam_role" {
  source = "git::https://github.com/TerraFlops/sumo-logic-iam-role?ref=v1.0"

  bucket_names = ["sumologic-logs-bucket","second-sumologic-logs-bucket"]
}
```
