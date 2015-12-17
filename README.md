# Osiris
Ruby gem to create Code Deploy artifacts, publishes them to S3 bucket, and then allows deployment.

[![Gem Version](https://badge.fury.io/rb/osiris.svg)](https://badge.fury.io/rb/osiris)

[![Build Status](https://travis-ci.org/wparad/Osiris.svg?branch=master)](https://travis-ci.org/wparad/Osiris)

### First Steps
Setup AWS to allow Code Deploy to work, i.e. decide on S3 buckets, deployment stratagy, on-site deployments.

[See on-site deployment](Onsite-Deployments.md)

###Development

    #!/usr/bin/env ruby

    require 'aws-sdk'
    require 'osiris'

    Aws.config.update({
      region: 'eu-west-1',
      credentials: Aws::Credentials.new(ENV['AWS_SECRET'], ENV['AWS_KEY'])
    })

    osiris = Osiris::Deployment.new(true)
    SERVICE_NAME = 'ServiceName'
    AWS_APPLICATION_NAME = 'AWS_APPLICATION_NAME'
    AWS_ENVIRONMENT_NAME = 'AWS_ENVIRONMENT_NAME'
    AWS_BUCKET_NAME = 's3-deployment-artifacts'
    task :publish do
      osiris.publish(AWS_BUCKET_NAME, SERVICE_NAME, PACKAGE_DIR, TravisBuildTools::Version.to_s)
    end

    task :publish do
      #deploy optionally takes an additonal argument which is an AWS CodeDeploy deployment description.
      osiris.deploy(AWS_BUCKET_NAME, SERVICE_NAME, VERSION, AWS_APPLICATION_NAME, AWS_ENVIRONMENT_NAME)
    end

Where

    /package/
        appspec.yml
        service/
            #service binaries
        deployment/
            #scripts needed by appspec.yml for deployment
