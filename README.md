<!-- Validate the written Terraform Script -->
terraform validate
<!-- This will give an error when there is .tfvars -->

<!-- Initialize Terraform -->
terraform init -upgrade
<!-- Create a Terraform execution plan -->
terraform plan -out main.tfplan

terraform plan -var-file="security_rules.tfvars" -var-file="credentials.tfvars" -out "main.tfplan"

<!-- Apply a Terraform execution plan -->
terraform apply "main.tfplan"

<!-- Refresh the all resources -->
terraform refresh

<!-- Clean up resources -->
terraform plan -var-file="security_rules.tfvars" -var-file="credentials.tfvars" -destroy -out "main.destroy.tfplan"

<!-- Apply a Terraform destruction plan -->
terraform apply "main.destroy.tfplan"