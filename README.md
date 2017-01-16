# Start Up

## Change task-definition

```
$ vim ./task-definitions/simple-app-container.json
```

# Run

```
$ terraform plan -var 'access_key=<access_key>' -var 'secret_key=<secret_key>' -var 'ssh_key_name=<ssh_key_name>'
$ terraform apply -var 'access_key=<access_key>' -var 'secret_key=<secret_key>' -var 'ssh_key_name=<ssh_key_name>'
```
