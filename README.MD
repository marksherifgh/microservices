# Steps to deploy
1. Created DockerFile for dockerizing the flask app
2. Added `.dockerignore` and `.gitignore` files
3. Created a github repository
4. Initialized git repository locally using `git init`
5. Created infra directory to have infrastructure and manifest files
6. Dockerized the application using the docker file I had already created `docker build -t msherif98/microservices:v1.0.0 .`
7. Pushed the docker image to my docker hub repository `docker login -u msherif -p <PASSWORD>` and pushed using `docker push msherif98/microservices:v1.0.0`
8. Wrote manifests for deployment and service for the flask app
9. Wrote the terraform file `main.tf` under terraform directory for provisioning `Azure AKS` cluster
10. Created CI/CD pipeline using github actions under `.github/workflows/deploy.yaml` to do the following:
    1. Build the flask app image and deploy it to my container registry given a docker access token
    2. Deploy the AKS cluster given my azure account creds `terraform plan` `terraform apply -auto-approve`
    3. Fetch the kubeconfig from AKS cluster `az aks get-credentials --resource-group microservice-rg --name microservice-aks`
    4. Apply the manifests using `kubectl apply -f deployment.yaml` and `kubectl apply -f service.yaml`
11. Added secrets for docker login and azure account to CI/CD pipeline variables