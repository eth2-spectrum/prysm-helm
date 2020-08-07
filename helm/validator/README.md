Prysm v2 keystore must reside in
```
config/wallet/all-accounts.keystore.json
```

Pass wallet password value override to the helm deployment.

Example:
```shell script
helm upgrade -i prysm-validator --set walletPassword=$(cat ~/tmp/wallet/password-file) .
```
