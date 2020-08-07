Pass validator keystore as include folder to the helm deployment.
Example:
```shell script
helm upgrade -i prysm-validator --set walletPassword=$(cat ~/tmp/wallet/password-file) .
```
