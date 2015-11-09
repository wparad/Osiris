# Osiris
Ruby gem to create Code Deploy artifacts, publishes them to S3 bucket, and then allows deployment.

[![Gem Version](https://badge.fury.io/rb/Osiris.svg)](http://badge.fury.io/rb/osiris)

[![Build Status](https://travis-ci.org/wparad/Osiris.svg?branch=master)](https://travis-ci.org/wparad/Osiris)

### First Steps
Setup AWS to allow Code Deploy to work, i.e. decide on S3 buckets, deployment stratagy, on-site deployments.

[See on-site deployment](Onsite-Deployments.md)

###Development

    #!/usr/bin/env ruby

    require 'aws-sdk'
    require 'osiris'

    Aws.use_bundled_cert!
    Aws.config.update({
      region: 'eu-west-1',
      credentials: Aws::Credentials.new(ENV['AWS_SECRET'], ENV['AWS_KEY'])
    })

    osiris = Osiris::Deployment.new()

    task :publish do
      osiris.publish('s3-deployment-artifacts', 'ServiceName', PACKAGE_DIR, TravisBuildTools::Version.to_s)
    end

    task :publish do
      osiris.deploy()
    end

Where

    /package/
        appspec.yml
        service/
            #service binaries
        deployment/
            #scripts needed by appspec.yml for deployment
