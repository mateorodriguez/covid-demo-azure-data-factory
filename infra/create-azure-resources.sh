az login

az storage account create --name testcoviddemodl --resource-group test-covid-demo-rg --location brazilsouth --sku Standard_LRS --kind StorageV2 --min-tls-version TLS1_2 --allow-blob-public-access false --public-network-access enabled --enable-hierarchical-namespace