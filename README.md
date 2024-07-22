# Wisecow Application Containerization and Deployment on Kubernetes

## Objective
Containerize and deploy the Wisecow application on a Kubernetes environment with secure TLS communication.

## Steps I Followed

### 1. Dockerization

1. **Edited the .sh File:**
   - Modified the `.sh` file to correctly locate the path of dependencies.

2. **Built Docker Image:**
   - Created a Docker image for the Wisecow application.

### 2. Kubernetes Deployment

1. **Created EKS Cluster:**
   - Used `eksctl` to create an EKS cluster named `wisecow` with 2 nodes in the `ap-south-1` region.
     ```
     eksctl create cluster --name wisecow --region ap-south-1 --nodes 2
     ```

2. **Updated Kubeconfig:**
   - Ran the command to update the kubeconfig to use the new EKS cluster.
     ```sh
     aws eks --region ap-south-1 update-kubeconfig --name wisecow
     ```

3. **Installed Helm:**
   - Installed Helm for managing Kubernetes applications.
     ```
     curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
     ```
   - Added the Jetstack Helm repository and updated the repo.
     ```
     helm repo add jetstack https://charts.jetstack.io
     helm repo update
     ```

4. **Set Up Cert-Manager for TLS:**
   - Applied Cert-Manager CRDs.
     ```
     kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.crds.yaml
     ```
   - Installed Cert-Manager using Helm.
     ```sh
     helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace
     ```

5. **Set Up NGINX Ingress Controller:**
   - Added the Ingress NGINX Helm repository and updated the repo.
     ```
     helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
     helm repo update
     ```
   - Installed NGINX Ingress Controller using Helm.
     ```
     helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
     ```

6. **Applied Kubernetes Manifests:**
   - Applied the Kubernetes deployment, service, ingress, and cluster issuer manifests to deploy the Wisecow application and set up secure TLS communication.
     ```
     kubectl apply -f deployment.yaml
     kubectl apply -f service.yaml
     kubectl apply -f ingress.yaml
     kubectl apply -f cluster-issuer.yaml
     ```

### 3. Continuous Integration and Deployment (CI/CD)

1. **Configured GitHub Actions Workflow:**
   - Set up GitHub Actions for CI/CD to automate Docker image builds and deployments to the Kubernetes cluster.
   - The workflow builds the Docker image, pushes it to a container registry, and deploys the updated application to Kubernetes.

### 4. TLS Implementation with Let's Encrypt

1. **Installed Cert-Manager:**
   - Used Cert-Manager to handle certificate management for the Kubernetes cluster.

2. **Configured Let's Encrypt:**
   - Configured Let's Encrypt as the certificate authority by creating a ClusterIssuer. This allows automatic provisioning and renewal of TLS certificates.

3. **Set Up Ingress for TLS:**
   - Configured an Ingress resource to use the Let's Encrypt-issued certificate for the domain `huzaif-shah.live`.
   - Ensured that the Ingress resource specifies the `cert-manager` annotations to request and use the TLS certificate.

4. **Domain Configuration:**
   - Made sure the domain `huzaif-shah.live` points to the Kubernetes cluster's ingress controller's IP address.

### 5. Access Control

1. **Set Repository to Public:**
   - Made sure the GitHub repository is set to public.

## End Goal
Successfully containerized and deployed the Wisecow application to the Kubernetes environment with an automated CI/CD pipeline and secure TLS communication using Let's Encrypt and the domain `huzaif-shah.live`.
