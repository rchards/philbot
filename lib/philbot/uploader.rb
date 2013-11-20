require 'fog/rackspace/models/storage/files'

module Philbot
  class Uploader
    @queue = :default

    def self.perform filenames
#     puts "Uploading %s" % filename
      rackspace = Fog::Storage.new(
          {
              provider:           'Rackspace',
              rackspace_username: 'raxdemotheodi', #ENV['RACKSPACE_USERNAME'],
              rackspace_api_key:  'qwerty', #ENV['RACKSPACE_API_KEY'],
              rackspace_region:   :lon #ENV['RACKSPACE_REGION'].to_sym
          }
      )

      dir = rackspace.directories.get ENV['RACKSPACE_DB_CONTAINER']
      filenames.each do |filename|
        dir.files.create :key => filename, :body => File.open(File.join(Philbot::Config.root, filename))
      end
    end
  end
end