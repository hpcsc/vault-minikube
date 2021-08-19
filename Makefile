build:
	kustomize build ./kubernetes

apply:
	kustomize build ./kubernetes | kubectl apply --context minikube -f -

unapply:
	kustomize build ./kubernetes | kubectl delete --context minikube -f -
