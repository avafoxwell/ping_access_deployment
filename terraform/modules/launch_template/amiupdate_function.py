import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    autoscaling = boto3.client('autoscaling')

    # Replace this with logic to select the latest AMI (you could get it from the SNS event)
    new_ami_id = "ami-NEWAMI"  # Retrieve this dynamically in a real implementation

    # Update Launch Template
    response = ec2.create_launch_template_version(
        LaunchTemplateId=os.environ['LAUNCH_TEMPLATE_ID'],
        VersionDescription='New AMI Update',
        LaunchTemplateData={
            'ImageId': new_ami_id
        }
    )
    new_version = response['LaunchTemplateVersion']['VersionNumber']

    # Update ASG with new Launch Template version
    autoscaling.update_auto_scaling_group(
        AutoScalingGroupName=os.environ['ASG_NAME'],
        LaunchTemplate={
            'LaunchTemplateId': os.environ['LAUNCH_TEMPLATE_ID'],
            'Version': str(new_version)
        }
    )

    # Start an instance refresh for the ASG
    autoscaling.start_instance_refresh(
        AutoScalingGroupName=os.environ['ASG_NAME'],
        Strategy='Rolling'
    )

    return {
        'statusCode': 200,
        'body': f"Updated Launch Template to version {new_version} and triggered instance refresh."
    }
