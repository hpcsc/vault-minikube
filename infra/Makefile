fmt:
	terraform fmt -recursive ./src

init:
	cd src && terraform init

OKTA_ORG_NAME = dev-25816939
VAULT_PORT = $(shell kubectl get svc vault --context minikube -n vault-minikube -o json | jq -r '.spec.ports[0].nodePort')
VAULT_ADDR = http://$(shell minikube ip):${VAULT_PORT}
VAULT_TOKEN = root

plan:
	cd src && \
		VAULT_TOKEN=${VAULT_TOKEN} \
		VAULT_ADDR=${VAULT_ADDR} \
			terraform plan \
				-var=vault_addr="${VAULT_ADDR}" \
				-var=okta_org_name=${OKTA_ORG_NAME}

apply:
	cd src && \
		VAULT_TOKEN=${VAULT_TOKEN} \
		VAULT_ADDR=${VAULT_ADDR} \
			terraform apply \
				-var=vault_addr="${VAULT_ADDR}" \
				-var=okta_org_name=${OKTA_ORG_NAME} \
				-auto-approve

destroy:
	cd src && \
		VAULT_TOKEN=${VAULT_TOKEN} \
		VAULT_ADDR=${VAULT_ADDR} \
			terraform destroy \
				-var=vault_addr="${VAULT_ADDR}" \
				-var=okta_org_name=${OKTA_ORG_NAME} \
				-auto-approve
