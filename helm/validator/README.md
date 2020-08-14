Prysm v2 keystore must reside in 
```
config/wallet/all-accounts.keystore.json
```
Create folder if not present.

Pass wallet password value override to the helm deployment. Contained in a file in this example.

Example:
```shell script
helm upgrade -i validator --set walletPassword=$(cat ~/tmp/wallet/password-file) .
```
The above example assumes that you have started the beacon node chart with the name `beacon-node`. 
You can override this value with `--set beaconNode=<your-beacon-node-service>`.