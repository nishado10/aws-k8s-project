# aws-k8s-project

This repository contains the code and configurations for deploying a simple web application in a cloud-based Kubernetes environment. The application will be containerized using Docker and deployed on AWS using EKS (Elastic Kubernetes Service). It includes a monitoring solution using **Prometheus** and **Grafana** for logging and visualization of application metrics.

## Prerequisites

Before you begin, make sure you have the following tools installed on your machine:

- **AWS CLI**: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **Terraform**: [Install Terraform](https://www.terraform.io/downloads.html)
- **kubectl**: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- **Helm**: [Install Helm](https://helm.sh/docs/intro/install/)
- **Docker**: [Install Docker](https://www.docker.com/get-started)

You also need an AWS account with the necessary IAM permissions to provision EKS and other AWS resources.

## Steps for Deployment

### Step 1: Provision AWS Infrastructure using Terraform

1. Create a `main.tf` file with the following content to provision an EKS cluster and node group.

   provider "aws" {
     region = "us-east-1"
   }

   resource "aws_eks_cluster" "my-cluster" {
     name     = "my-cluster"
     role_arn = "<iam_role_arn>"
     vpc_config {
       subnet_ids = ["<subnet_id>"]
     }
   }

   resource "aws_eks_node_group" "my-node-group" {
     cluster_name    = aws_eks_cluster.my-cluster.name
     node_role_arn   = "<iam_role_arn>"
     subnet_ids      = ["<subnet_id>"]
     instance_types  = ["t3.medium"]
     desired_size    = 2
   }
   
2. Run the following Terraform commands to provision the infrastructure:

   terraform init
   terraform apply

###  Step 2: Set Up Kubernetes:

1. Install kubectl from the official Kubernetes documentation: kubectl Install

2. After provisioning the EKS cluster, configure kubectl to access the cluster:

   aws eks --region us-east-1 update-kubeconfig --name my-cluster

### Step 3: Containerize the Web Application

1. Create a Dockerfile for the web application:
   FROM nginx:latest
   COPY index.html /usr/share/nginx/html/index.html
   EXPOSE 80
   
3. Build and push the Docker image to Docker Hub:
   docker build -t my-web-app .
   docker tag my-web-app <dockerhub_username>/my-web-app
   docker push <dockerhub_username>/my-web-app
   
### Step 4: Deploy Application in Kubernetes

1.Create a deployment.yaml file for deploying the web application:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-web-app
  labels:
    app: my-web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-web-app
  template:
    metadata:
      labels:
        app: my-web-app
    spec:
      containers:
        - name: my-web-app
          image: <dockerhub_username>/my-web-app
          ports:
            - containerPort: 80
            
2.Create a service.yaml file to expose the application:

apiVersion: v1
kind: Service
metadata:
  name: my-web-app-service
spec:
  selector:
    app: my-web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
  
3.Apply the Kubernetes configuration:

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

### Step 5: Set Up Prometheus Monitoring

1.Install Prometheus using Helm:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

2.Create a service-monitor.yaml file to configure Prometheus to scrape metrics from the web application:

apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-web-app-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: my-web-app
  endpoints:
    - port: 80
      interval: 30s

3. Apply the ServiceMonitor configuration:

kubectl apply -f service-monitor.yaml





