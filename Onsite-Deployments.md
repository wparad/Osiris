# Code Deploy Setup
Sample project using AWS CodeDeploy for on-site premise instances

### General Guidelines

* Access remote machines
* Go to the individual machines and run the setup commands:
    * [install aws cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
    * `aws configure`
        * region: `us-east-1`
        * Use create user to complete the local actions with `deployment_setup_user` security auth with

```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Stmt1445880926000",
                "Effect": "Allow",
                "Action": [
                    "iam:CreateUser"
                ],
                "Resource": [
                    "arn:aws:iam::971193568016:user/AWS/CodeDeploy/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "codedeploy:*",
                    "iam:CreateAccessKey",
                    "iam:CreateUser",
                    "iam:DeleteAccessKey",
                    "iam:DeleteUser",
                    "iam:DeleteUserPolicy",
                    "iam:ListAccessKeys",
                    "iam:ListUserPolicies",
                    "iam:PutUserPolicy",
                    "iam:GetUser",
                    "tag:GetTags",
                    "tag:GetResources"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:*",
                    "s3:List*"
                ],
                "Resource": [
                    "arn:aws:s3:::aws-codedeploy-us-east-1/*",
                    "arn:aws:s3:::aws-codedeploy-us-west-2/*",
                    "arn:aws:s3:::aws-codedeploy-eu-west-1/*",
                    "arn:aws:s3:::aws-codedeploy-eu-central-1/*",
                    "arn:aws:s3:::aws-codedeploy-ap-southeast-2/*",
                    "arn:aws:s3:::aws-codedeploy-ap-northeast-1/*"
                ]
            }
        ]
    }
```

* (cont...)
    * `cd C:/AWSCLI/`
    * `aws deploy register --tags Key=Environment,Value=ENVIRONMENT_NAME --instance-name HOSTNAME`
        * This will create a new user specifically for this instance.
    * `aws deploy install --config-file codedeploy.onpremises.yml`
* Go to CodeDeploy GUI add Application and on-Premise machines.
* Take results and update AWS console by creating a new deployment.
* Determine how to create deployment packages
    * Create S3 Bucket, only one is needed for s3-deployment-artifacts
* Create package:
    * Add all necessary scripts and the [appspec.yml](http://docs.aws.amazon.com/codedeploy/latest/userguide/app-spec-ref.html) file.
* Deploy packages to S3 here: [S3 Bucket](https://console.aws.amazon.com/s3/home?region=us-east-1#&bucket=s3-deployment-artifacts/).
* Deploy using deployment package [AWS CodeDeploy](https://console.aws.amazon.com/codedeploy/home?region=us-east-1#/deployments).

### Sample test

* Make sure the current user has access to:
** S3 Bucket for editing/uploading files
** Action to execute CodeDeploy for self user in the AWS Console (and create applications/deployment configurations)

```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Stmt1445342669000",
                "Effect": "Allow",
                "Action": [
                    "codedeploy:*"
                ],
                "Resource": [
                    "*"
                ]
            },
            {
                "Sid": "Stmt1446574443000",
                "Effect": "Allow",
                "Action": [
                    "s3:*"
                ],
                "Resource": [
                    "arn:aws:s3:::s3-deployment-artifacts/*"
                ]
            }
        ]
    }
```

* Add new machine machine to [On-Premise machines](https://console.aws.amazon.com/codedeploy/home?region=us-east-1#/onPremisesInstances).
    * [install aws cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
    * `aws configure`
        * Use deployment_setup_user security auth [AWS deployment_setup_user user](https://console.aws.amazon.com/iam/home?region=us-east-1#users/deployment_setup_user).
        * region: `us-east-1`
    * `cd C:/AWSCLI/`
    * `aws deploy register --tags Key=Environment,Value=Setup --instance-name MyLocalDatacenterMachine`
    * `aws deploy install --config-file codedeploy.onpremises.yml`
* Created Application
* Created a Deployment group
* Created an appspec.yml file:

        version: 0.0
        os: windows

* Create a tarball from file (create tarball called 1.0.tar.gz and add file appspec.yml) <code>tar -czf 1.0.tar.gz appspec.yml</code>
* Uploaded tarball to S3 bucket: [S3 Bucket](https://console.aws.amazon.com/s3/home?region=us-east-1#&bucket=s3-deployment-artifacts).
* Create a deployment [AWS CodeDeploy](https://console.aws.amazon.com/codedeploy/home?region=us-east-1#/deployments)
    * Using the Application.
    * Using Deployment Configuration.
    * Specify S3 bucket location: `s3://s3-deployment-artifacts/1.0.tar.gz`
    * click Deploy