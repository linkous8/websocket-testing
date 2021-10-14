#! /bin/bash

NAMESPACE=${NAMESPACE:-`kubectl config get-contexts | awk '/^\*/ {print $5}'`}
echo $NAMESPACE
kubectl get ns ${NAMESPACE:-websocket-testing} >& /dev/null
if [ $? -eq 0  ]; then
  NAMESPACE=websocket-testing
  echo "Namespace '${NAMESPACE}' exists"
  echo ""
  echo "You will need to ensure that your opsani services use"
  echo "this same namespace parameter"
  echo ""
  echo "you can set this as your default with:"
  echo "kubectl config set-context `kubectl config get-contexts | awk '/^\*/ {print $2}'` --namespace ${NAMESPACE}"
  echo ""
else
  NAMESPACE=websocket-testing
  echo "Creating ${NAMESPACE} namespace"
  kubectl create ns ${NAMESPACE} >& /dev/null
  if [ $? -ne 0 ]; then
    echo "Couldn't create kubernetes namespace '${NAMESPACE}'"
    echo "You must set the NAMESPACE enviornment variable for the target "
    echo "e.g. `export NAMESPACE=${NAMESPACE}`"
    exit 1
  else
    echo "created namespace $NAMESPACE"
    echo "deploying into ${NAMESPACE}"
    echo ""
    echo ""
  fi
fi

kubectl apply -n ${NAMESPACE} -f ./kubernetes-manifests/
if [ $? -ne 0 ]; then
  echo ""
  echo "a component may have failed to install.  Please look at the above output for errors"
  exit 1
else
  echo ""
  echo ""
  echo "Websocket testing resources were installed in ${NAMESPACE}"
  echo "You can try to port-forward to the websocket-echo service with"
  echo "kubectl port-forward -n ${NAMESPACE} svc/frontend 8080:80 &"
  echo "and point a client to http://localhost:8080/ (eg. 'python -m websockets ws://localhost:8080/'"
fi
