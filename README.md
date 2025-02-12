## Steps for Deployment

Step 1: Provision AWS Infrastructure using Terraform
Create a main.tf file to define the AWS infrastructure (EKS cluster, node group, VPC, etc.) using Terraform.
Initialize Terraform and apply the configuration to provision the infrastructure.

Step 2: Set Up Kubernetes
Install kubectl to manage Kubernetes clusters.
Once the EKS cluster is created, configure kubectl to access the cluster by updating your kubeconfig.

Step 3: Containerize the Web Application
Create a Dockerfile to containerize the web application (e.g., a static webpage).
Build the Docker image locally and push it to a container registry (e.g., Docker Hub).

Step 4: Deploy Application in Kubernetes
Create a Kubernetes Deployment manifest to deploy the containerized web application.
Create a Kubernetes Service manifest to expose the application (using LoadBalancer type).
Apply the Kubernetes manifests using kubectl to deploy the application in the cluster.

Step 5: Set Up Prometheus Monitoring
Install Prometheus using Helm to collect metrics from the Kubernetes cluster.
Create a ServiceMonitor configuration to scrape metrics from the deployed web application.
Apply the ServiceMonitor configuration using kubectl.
