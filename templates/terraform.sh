#!/bin/bash

help_message() {
  echo -e "Usage: $0 [apply|destroy|plan|refresh|show|state|output]\n"
  echo -e "The following arguments are supported:"
  echo -e "\tapply   \t Refresh the Terraform remote state, perform a \"terraform get -update\", and issue a \"terraform apply\""
  echo -e "\tdestroy \t Refresh the Terraform remote state and destroy the Terraform stack"
  echo -e "\tplan    \t Refresh the Terraform remote state, perform a \"terraform get -update\", and issues a \"terraform plan\""
  echo -e "\toutput \t Refresh the Terraform remote state and perform a \"terraform output\""
  echo -e "\trefresh \t Refresh the Terraform remote state"
  echo -e "\tshow    \t Refresh and show the Terraform remote state"
  echo -e "\tstate   \t Refresh the Terraform remote state and perform a \"terraform state\""
  exit 1
}

createBackendConfig() {
  /bin/cat > backend.tf <<EOL
terraform {
  backend "s3" {}
}
EOL
}

output() {
  refresh
  shift
  terraform output $@
}

apply() {
  plan
  echo -e "\n\n***** Running \"terraform apply\" *****"
  terraform apply -auto-approve=true
}

destroy() {
  shift
  plan -destroy $@
  echo -e "\n\n***** Running \"terraform destroy\" *****"
  terraform destroy $@
}

plan() {
  refresh
  terraform get -update
  echo -e  "\n\n***** Running \"terraform plan\" *****"

  echo $*
  if [ $1 == "-destroy" ]; then
    terraform plan $@
  elif [ $# -gt 1 ]; then
    shift
    terraform plan $@
  else
    terraform plan
  fi
}

refresh() {
  # parse pwd and remove everything before "aws"
  IFS="/" read -ra PARTS <<< "$(pwd)"
  for i in "${!PARTS[@]}"; do
    if [ "${PARTS[$i]}" == "aws" ]; then
      START_POS=$i
    fi
  done
  PARTS=("${PARTS[@]:${START_POS}+1}")

  # account terraform
  if [ "${#PARTS[@]}" == "1" ]; then
    refresh_account_terraform
  # vpc terraform
  elif [ "${#PARTS[@]}" == "3" ]; then
    refresh_vpc_terraform
  # service terraform
  elif [ "${#PARTS[@]}" == "5" ]; then
    refresh_service_terraform
  fi
}

refresh_account_terraform() {
  root=$(pwd | awk -F "/" '{print $(NF-1)}')
  aws_account=$(pwd | awk -F "/" '{print $NF}')

  export TF_VAR_root="$root"
  export TF_VAR_aws_account="$aws_account"
  export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

  echo -e "\n\n***** Refreshing State and Upgrading Modules *****"

  echo "no" | terraform init -get=true \
                             -upgrade \
                             -input=false \
                             -backend=true \
                             -backend-config "bucket=${aws_account}-terraform-state" \
                             -backend-config "key=${root}/terraform.tfstate" \
                             -backend-config "profile=${aws_account}" \
                             -backend-config "region=us-east-1"
}

refresh_vpc_terraform() {
  root=$(pwd | awk -F "/" '{print $(NF-3)}')
  aws_account=$(pwd | awk -F "/" '{print $(NF-2)}')
  aws_region=$(pwd | awk -F "/" '{print $(NF-1)}')
  vpc_name=$(pwd | awk -F "/" '{print $(NF)}')

  export TF_VAR_root="$root"
  export TF_VAR_aws_account="$aws_account"
  export TF_VAR_aws_region="$aws_region"
  export TF_VAR_vpc_name="$vpc_name"
  export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

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

refresh_service_terraform() {
  root=$(pwd | awk -F "/" '{print $(NF-5)}')
  aws_account=$(pwd | awk -F "/" '{print $(NF-4)}')
  aws_region=$(pwd | awk -F "/" '{print $(NF-3)}')
  vpc_name=$(pwd | awk -F "/" '{print $(NF-2)}')
  environment_name=$(pwd | awk -F "/" '{print $(NF-1)}')
  service_name=$(pwd | awk -F "/" '{print $NF}')

  export TF_VAR_root="$root"
  export TF_VAR_aws_account="$aws_account"
  export TF_VAR_aws_region="$aws_region"
  export TF_VAR_vpc_name="$vpc_name"
  export TF_VAR_environment_name="$environment_name"
  export TF_VAR_service_name="$service_name"
  export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

  echo -e "\n\n***** Refreshing State and Upgrading Modules *****"

  echo "no" | terraform init -get=true \
                             -upgrade \
                             -input=false \
                             -backend=true \
                             -backend-config "bucket=${aws_account}-terraform-state" \
                             -backend-config "key=${root}/${aws_region}/${vpc_name}/${environment_name}/${service_name}/terraform.tfstate" \
                             -backend-config "profile=${aws_account}" \
                             -backend-config "region=us-east-1"
}

show() {
  refresh
  echo -e "\n\n***** Running \"terraform show\"  *****"
  terraform show
}

state() {
  refresh
  shift
  echo -e "\n\n***** Running \"terraform state $@\" *****"
  terraform state $@
}

## Begin script ##
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  help_message
fi

[ -z backend.tf ] || createBackendConfig
[ -d $HOME/.terraform.d/plugin-cache ] || mkdir -p $HOME/.terraform.d/plugin-cache

ACTION="$1"

case $ACTION in
  apply|destroy|plan|output|refresh|show|state)
    $ACTION $@
    ;;
  ****)
    echo "That is not a vaild choice."
    help_message
    ;;
esac
