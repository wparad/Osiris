require 'aws-sdk'

module Osiris
  class Deployment
    def initialize()
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
  end
end