#!/bin/bash
set -e

# =========================
# Update packages
# =========================
apt-get update -y

# =========================
# Install Docker
# =========================
apt-get install -y docker.io curl conntrack

# Start and enable Docker
systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# =========================
# Install kubectl
# =========================
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl kubectl.sha256

# =========================
# Install minikube
# =========================
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# =========================
# Start minikube as ubuntu user
# =========================
su - ubuntu -c "minikube start --driver=docker"

# =========================
# Create Kubernetes manifest file
# =========================
cat <<'EOF' > /home/ubuntu/node.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-nginx-deployment
  labels:
    app: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: hoangcute
          image: nginx:latest
          ports:
            - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: hello-nginx-service
spec:
  type: NodePort
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30007
EOF

# Fix file owner
chown ubuntu:ubuntu /home/ubuntu/node.yaml

# =========================
# Apply Kubernetes manifest
# =========================
su - ubuntu -c "kubectl apply -f /home/ubuntu/node.yaml"

# Wait for pods to be created
sleep 20

# Check resources
su - ubuntu -c "kubectl get pods -o wide"
su - ubuntu -c "kubectl get svc"

# =========================
# Port forward service to EC2 public IP
# =========================
su - ubuntu -c "nohup kubectl port-forward --address 0.0.0.0 service/hello-nginx-service 8080:80 > /home/ubuntu/port-forward.log 2>&1 &"