# medalla-prysm
Helm chart to run the prysmatic eth2 client in the medalla testnet.

This chart generally targets microk8s clusters running on raspberry pis, but can easily be generalized to k8s clusters on other host environments.

To make this work out of the box, the Prysm v2 keystore must reside in 
```
validator/config/wallet/all-accounts.keystore.json
```
Create folder if not present.
You also need to pass wallet password value override to the helm deployment. Contained in a file in the example below.

deploy the helm charts as such:
```shell script
$ helm upgrade -i beacon-node ./beacon-node
$ helm upgrade -i validator --set walletPassword=$(cat <path-to-my-pw-file>) ./validator
$ helm upgrade -i --debug monitoring ./monitoring
```

issues and pull requests are very welcome!
