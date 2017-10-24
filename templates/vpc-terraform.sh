#!/bin/bash
# Must be run in the service's directory.

help_message() {
  echo -e "Usage: $0 [apply|destroy|plan|refresh|show]\n"
  echo -e "The following arguments are supported:"
  echo -e "\tapply   \t Refresh the Terraform remote state, perform a \"terraform get -update\", and issue a \"terraform apply\""
  echo -e "\tdestroy \t Refresh the Terraform remote state and destroy the Terraform stack"
  echo -e "\tplan    \t Refresh the Terraform remote state, perform a \"terraform get -update\", and issues a \"terraform plan\""
  echo -e "\trefresh \t Refresh the Terraform remote state"
  echo -e "\tshow    \t Refresh and show the Terraform remote state"
  exit 1
}
 
createBackendConfig() {
  /bin/cat > backend.tf <<EOL
terraform {
  backend "s3" {}
}
EOL
}

apply() {
  plan
  echo -e "\n\n***** Running \"terraform apply\" *****"
  terraform apply -auto-approve=true
}

destroy() {
  shift
  plan destroy $@
  echo -e "\n\n***** Running \"terraform destroy\" *****"
  terraform destroy $@
}

plan() {
  refresh
  terraform get -update
  echo -e  "\n\n***** Running \"terraform plan\" *****"

  if [ "$1" = "destroy" ]; then
    if [ $# -gt 1 ]; then
      terraform plan -$@
    else
      terraform plan -destroy
    fi
  else
    terraform plan
  fi
}

refresh() {
  root=$(pwd | awk -F "/" '{print $(NF-3)}')
  aws_account=$(pwd | awk -F "/" '{print $(NF-2)}')
  aws_region=$(pwd | awk -F "/" '{print $(NF-1)}')
  vpc_name=$(pwd | awk -F "/" '{print $(NF)}')

  export TF_VAR_root="$root"
  export TF_VAR_aws_account="$aws_account"
  export TF_VAR_aws_region="$aws_region"
  export TF_VAR_vpc_name="$vpc_name"
  export TF_PLUGIN_CACHE_DIR="~/.terraform.d/plugin-cache"

  echo -e "\n\n***** Refreshing State and Upgrading Modules *****"

  echo "no" | terraform init -get=true \
                             -upgrade \
                             -input=false \
                             -backend=true \
                             -backend-config "bucket=${aws_account}-terraform-state" \
                             -backend-config "key=${root}/${aws_region}/${vpc_name}/terraform.tfstate" \
                             -backend-config "profile=${aws_account}" \
                             -backend-config "region=us-east-1"
}

show() {
  refresh
  echo -e "\n\n***** Running \"terraform show\"  *****"
  terraform show
}

## Begin script ## 
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  help_message
fi

[ -z backend.tf ] || createBackendConfig 
[ -d ~/.terraform.d/plugin-cache ] || mkdir -p ~/.terraform.d/plugin-cache

ACTION="$1"

case $ACTION in
  apply|destroy|plan|refresh|show)
    $ACTION $@
    ;;
  ****)
    echo "That is not a vaild choice."
    help_message
    ;;
esac
