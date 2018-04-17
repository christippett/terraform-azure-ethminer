# Mine Ethereum on Azure with Terraform

## Setup
### 1. Configure Ethereum wallet address and work server
Edit `bootstrap.sh` and update the URL of your work server.

```bash
walletaddress="http://eth-eu.dwarfpool.com:80/ETHEREUM_WALLET"
```

### 2. Set Terraform variables
1. **ssh_key**

   SSH public key that will copied to the instance. This will allow Terraform to run the `remote-exec` provisioner via SSH.
2. **region**

   Azure region to deploy to.
3. **resource_group**

   Name of the Azure resource group that all resources will be deployed to.
3. **prefix**

   All Azure resources will be prefixed with this value.
4. **subnet_cidr**

   CIDR to use when setting up the Azure virtual network and subnet.
5. **instance_count**

   How many instances to deploy that will run Ethminer.
6. **instance_type**

   Azure machine type to deploy.

### 3. Deploy
Run `terraform apply` to deploy to Azure.

Once deployed, all instances will execute `bootstrap.sh`, which will install dependencies and start running Ethminer.