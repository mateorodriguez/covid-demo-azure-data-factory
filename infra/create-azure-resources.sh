# Login to az using your credentials
az login

# Create a blob storage account
# Replace --name, --resource-group and --location values
az storage account create --name a-random-name --resource-group a-random-group --location brazilsouth --sku Standard_LRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false --public-network-access enabled

# Create a data lake storage account
# Replace --name, --resource-group and --location values
az storage account create --name a-random-name --resource-group a-random-group --location brazilsouth --sku Standard_LRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false --public-network-access enabled --enable-hierarchical-namespace