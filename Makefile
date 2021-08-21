build:
	kustomize build ./kubernetes

apply:
	kustomize build ./kubernetes | kubectl apply --context minikube -f -

unapply:
	kustomize build ./kubernetes | kubectl delete --context minikube -f -

login-as-default-sa:
	$(eval VAULT_PORT=$(shell kubectl get svc vault --context minikube -n vault-minikube -o json | jq -r '.spec.ports[0].nodePort'))
	$(eval export VAULT_ADDR=http://$(shell minikube ip):${VAULT_PORT})
	@./scripts/login-as-sa.sh default

get-secret:
	$(eval VAULT_PORT=$(shell kubectl get svc vault --context minikube -n vault-minikube -o json | jq -r '.spec.ports[0].nodePort'))
	$(eval export VAULT_ADDR=http://$(shell minikube ip):${VAULT_PORT})
	vault kv get ${SECRET}

render-local-template:
	$(eval VAULT_PORT=$(shell kubectl get svc vault --context minikube -n vault-minikube -o json | jq -r '.spec.ports[0].nodePort'))
	rm -rf ./tmp && mkdir -p ./tmp
	./scripts/get-sa-token.sh > ./tmp/token
	vault agent -address=http://$(shell minikube ip):${VAULT_PORT} -config=templates/local.hcl
