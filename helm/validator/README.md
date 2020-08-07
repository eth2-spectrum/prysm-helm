Prysm v2 keystore must reside in 
```
config/wallet/all-accounts.keystore.json
```
Create folder if not present.

Pass wallet password value override to the helm deployment.

Example:
```shell script
helm upgrade -i prysm-validator --set walletPassword=$(cat ~/tmp/wallet/password-file) .
```
