#!/bin/bash -e
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
 
apply() {
  plan
  echo -e "\n\n***** Running \"terraform apply\" *****"
  terraform apply
}

destroy() {
  plan
  echo -e "\n\n***** Running \"terraform destroy\" *****"
  terraform destroy
}

plan() {
  refresh
  terraform get -update
  echo -e  "\n\n***** Running \"terraform plan\" *****"
  terraform plan
}

refresh() {

  account=$(pwd | awk -F "/" '{print $(NF-4)}')
  region=$(pwd | awk -F "/" '{print $(NF-3)}')
  vpc=$(pwd | awk -F "/" '{print $(NF-2)}')
  environment=$(pwd | awk -F "/" '{print $(NF-1)}')
  service=$(pwd | awk -F "/" '{print $NF}')

  echo -e "\n\n***** Refreshing State *****"

  terraform remote config -backend=s3 \
                          -backend-config="bucket=${account}" \
                          -backend-config="key=${region}/${vpc}/${environment}/${service}/terraform.tfstate" \
                          -backend-config="region=us-east-1"
}

show() {
  refresh
  echo -e "\n\n***** Running \"terraform show\"  *****"
  terraform show
}

## Begin script ## 
if [ "$#" -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  help_message
fi

ACTION="$1"

case $ACTION in
  apply|destroy|plan|refresh|show)
    $ACTION 
    ;;
  ****)
    echo "That is not a vaild choice."
    help_message
    ;;
esac
