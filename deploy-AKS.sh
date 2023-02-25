# Note - these commands do not run end-to-end yet, but are a work in progress
# Set Up env vars for this script
# rgandacrandaksname=will be used for the resource group, acr and k8s cluster name
# mylocation=will be used for the location of all resources
# myResourceGroup=will be used for the resource group
# myACRName=will be used for the acr name
# myAKSCluster=will be used for the k8s cluster name
# Run locally: 
# mvn package
# mvn spring-boot:run
# 
# Run with docker 
# docker build -t openaibot . 
# run -p 8080:8080 -e APPLICATION_OPENAI_KEY -e APPLICATION_OPENAI_URL openaibot 
# Access the app at http://localhost:8080/feature
# Azure locations: az account list-locations -o table

# Required:
export mylocation=<select from az account list-locations -o table>
export rgandacrandaksname=<your-name-for-rg-and-acr-and-aks-cluster>
export APPLICATION_OPENAI_KEY=<your-openai-api-key>
export APPLICATION_OPENAI_URL=<your-openai-url>

#Optional, otherwise pre-assigned from above: 
export myResourceGroup=$rgandacrandaksname
export myACRName=$rgandacrandaksname
export myACRImage=$myACRName:v1
export myAKSCluster=$rgandacrandaksname
export myAppGWname=$rgandacrandaksname

# Create a resource group.
az group create --location $mylocation --name $myResourceGroup

# Create an Azure Container Registry.
az acr create --resource-group $myResourceGroup --name $myACRName --location $mylocation --sku Standard --admin-enabled true

# Get the full registry ID for subsequent steps.
az acr login --name $myACRName

az acr build --registry $myACRName --image $myACRImage .

# Create a Kubernetes cluster. This can take a few minutes.
az aks create --resource-group $myResourceGroup --name $myAKSCluster --location $mylocation --node-count 1 --generate-ssh-keys --attach-acr $myACRName --enable-addons ingress-appgw --appgw-name $myAppGWname --appgw-subnet-cidr "10.225.0.0/16"  --enable-addons http_Application_Routing

# add http_application_routing after the install of the cluster
# check ingress via the portal - AKS > Services and Igresses > Ingress
az aks enable-addons --resource-group $myResourceGroup --name $myAKSCluster --addons http_application_routing

# Replace Resource Group and Cluster Name
az aks enable-addons --resource-group aks-rg2 --name aksdemo2 --addons http_application_routing

#In case of ingress issues, reset the app gateway and the http ingress controller:
# az aks disable-addons -a ingress-appgw -n $myAKSCluster -g $myResourceGroup
# az aks disable-addons -a http_application_routing -n $myAKSCluster -g $myResourceGroup
# az aks enable-addons --name $myAKSCluster --resource-group $myResourceGroup --addons ingress-appgw --appgw-subnet-cidr 10.225.0.0/16 --appgw-name $myAppGWname
# az aks enable-addons --resource-group $myResourceGroup --name $myAKSCluster --addons http_application_routing

az aks install-cli
# Windows: If not set up, set PATH=%PATH%;<localdir>.azure-kubectl after CLI install 

az aks get-credentials --resource-group $myResourceGroup --name $myAKSCluster --overwrite-existing

# Set up an env var secret (pre-created):
# Check out the secret - AKS > Configuration > Secrets > appconfigstring

kubectl create secret generic aiconfigstring --from-literal=APPLICATION_OPENAI_KEY=${APPLICATION_OPENAI_KEY} --from-literal=APPLICATION_OPENAI_URL=${APPLICATION_OPENAI_URL}

# Set up ingress control in the deployment

az aks show --resource-group $myResourceGroup --name $myAKSCluster --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table

# Manual step: edit the openaibot.yaml file and edit 2 items: 
# 1. Add the ingress host name 
# 2. Add the ACR image name

#Run 
kubectl apply -f openaibot.yaml
