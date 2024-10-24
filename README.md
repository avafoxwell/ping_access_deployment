# ping_access_deployment
A development repo to create ping access clustered engine deployments 
The purpose of this repo is to 
1. Provide a full CI/CD deployment using Terraform that deploys AWS Auto Scaling Group (ASG) with a Launch Template, and also includes an Amazon SNS topic and a Lambda function that updates the AMI and triggers an AWS Auto Scaling instance refresh. 