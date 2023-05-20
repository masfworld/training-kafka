# training-kafka

Terraform code to deploy GKS cluster with Apache Kafka using a static IP

#### Check Static IP address
`gcloud compute addresses describe kafka-static-ip`

#### Update kubeconfig
`gcloud container clusters get-credentials training-cluster --region=us-east1-b`

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