# training-kafka

Terraform code to deploy GKS cluster with Apache Kafka using a static IP

#### How to generate Credential JSON file credentials.json

1. Enabling [Kubernetes Engine API](https://console.cloud.google.com/apis/enableflow?apiid=container.googleapis.com) and [IAM Service Account Credentials API](https://console.cloud.google.com/apis/api/iamcredentials.googleapis.com/) in Google Cloud
2. Create a service account: Click Create Service Account at the top of the page. You will be prompted to enter details like the Service account name, Service account ID, and a description.

3. Grant service account permissions:
- Compute Admin
- Compute Network Admin
- Compute Public IP Admin
- Editor
- Kubernetes Engine Admin
- Kubernetes Engine Cluster Admin
- Secret Manager Secret Accessor
- Service Account Admin
- Service Account User
- Secret Manager Admin

1. Generate a key file: Once the service account is created, you can create a JSON key file for it. Click on the three dots under Actions, then Manage keys, and then Add Key > Create new key. Make sure JSON is selected as the Key type, and then click Create. The JSON key file will be downloaded to your computer.

#### Deploy GKS
```
cd terraform/gks
terraform apply --auto-aprove
```

#### Deploy Kafka
```
cd terraform/kafka
terraform apply --auto-aprove
```

#### Check Static IP address
`gcloud compute addresses describe kafka-static-ip --region=us-east1`

#### Update kubeconfig in your local machine
`gcloud container clusters get-credentials training-cluster --region=us-east1-b`

#### Run python script to replicate Tweets
You will need to create a secret in Google Cloud called `BEARER_TOKEN` which contains the token to use with Twitter