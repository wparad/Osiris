require 'aws-sdk'

module Osiris
  class Deployment
    def initialize(use_bundled_cert)
      Aws.use_bundled_cert! if use_bundled_cert
    end

    def publish(bucket, relative_path, local_directory, version)
      Dir.mktmpdir do |tmp|
        zip_file = File.join(tmp, "#{version.to_s}.zip")
        ZipFileGenerator.new().write(local_directory, zip_file);

        begin
          s3 = Aws::S3::Resource.new()
          obj = s3.bucket(bucket).object(File.join(relative_path, File.basename(zip_file)))
          obj.upload_file(zip_file)
        rescue Aws::S3::Errors::ServiceError => exception
          puts "Failed to publish resource: #{exception}"
        rescue Exception => exception
          puts "Failed to connect to AWS: #{exception}"
        end
      end
    end
    
    def deploy(bucket, relative_path, version, application_name, deployment_group, description = nil)
      begin
        codedeploy = Aws::CodeDeploy::Client.new()
        codedeploy.create_deployment({
          application_name: application_name, # required
          deployment_group_name: deployment_group,
          revision: {
            revision_type: 'S3',
            s3_location: {
              bucket: bucket,
              key: File.join(relative_path, "#{version.to_s}.zip"),
              bundle_type: 'zip'
            }
          },
          deployment_config_name: 'CodeDeployDefault.OneAtATime',
          description: description || "Deployed with Osiris, for more information see: https://github.com/wparad/Osiris",
          ignore_application_stop_failures: false
        })
      rescue Aws::CodeDeploy::Errors::ServiceError
        puts "Failed to deploy resource: #{exception}"
      rescue Exception => exception
        puts "Failed to connect to AWS: #{exception}"
      end
    end

  end
end