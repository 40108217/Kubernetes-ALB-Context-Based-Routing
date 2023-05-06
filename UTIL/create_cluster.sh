echo "Which AWS profile to set for creating the cluster"
read  profile_name

export AWS_DEFAULT_PROFILE="$profile_name"
sleep   5

echo  "Enter the cluster name"
read cluster_name
echo "Creating Cluster $cluster_name ..."

eksctl create cluster --name=$cluster_name \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --version="1.26" \
                      --without-nodegroup 

sleep   30

echo  "Enabling AWS IAM roles for Kubernetes service accounts on our EKS cluster, by creating & associate OIDC identity provider"
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster $cluster_name \
    --approve
sleep   5

echo "Node-Group Creation in progress..."
eksctl create nodegroup --cluster=$cluster_name \
                       --region=us-east-1 \
                       --name=$cluster_name-ng-private1 \
                       --node-type=t3.medium \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=veru-eks \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access \
                       --node-private-networking


