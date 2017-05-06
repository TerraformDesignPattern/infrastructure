#!/bin/bash
# Must be run in the service's directory.

help_message() {
  echo -e "Usage: $0 [apply|destroy|plan|refresh|show]\n"
  echo -e "The following arguements are supported:"
  echo -e "\tapply   \t Refresh the Terraform remote state, perform a \"terraform get -update\", and issue a \"terraform apply\""
  echo -e "\tdestroy \t Refresh the Terraform remote state and destroy the Terraform stack"
  echo -e "\tplan    \t Refresh the Terraform remote state, perform a \"terraform get -update\", and issues a \"terraform plan\""
  echo -e "\trefresh \t Refresh the Terraform remote state"
  echo -e "\tshow    \t Refresh and show the Terraform remote state"
  exit 1
}
 
apply() {
  refresh
  terraform get -update
  terraform apply
}

destroy() {
  refresh
  terraform get -update
  terraform destroy
}

plan() {
  refresh
  terraform get -update
  terraform plan
}

refresh() {

  account=$(pwd | awk -F "/" '{print $(NF-2)}')
  region=$(pwd | awk -F "/" '{print $(NF-1)}')
  vpc=$(pwd | awk -F "/" '{print $(NF)}')

  terraform remote config -backend=s3 \
                          -backend-config="bucket=${account}" \
                          -backend-config="key=${region}/${vpc}/terraform.tfstate" \
                          -backend-config="region=us-east-1"
}

show() {
  refresh
  terraform show
}

## Begin script ## 
if [ "$#" -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  help_message
fi

action="$1"

case $action in
  apply)
    apply
    ;;
  destroy)
    destroy
    ;;
  plan)
    plan 
    ;;
  refresh)
    refresh 
    ;;
  show)
    show 
    ;;
  ****)
    echo "That is not a vaild choice."
    help_message
    ;;
esac
