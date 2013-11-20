require "resque"
require 'listen'
require 'fog'

require "philbot/version"
require 'philbot/config'
require 'philbot/uploader'

module Philbot
  def self.run watchdir
    Philbot::Config.root = watchdir

    @@listener = Listen.to watchdir do |modified, added, removed|
#      puts "modified absolute path: #{modified}"
#      puts "removed absolute path: #{removed}"
      if added
#        puts "added absolute path: #{added}, #{watchdir}"
        Resque.enqueue Philbot::Uploader, added.map{ |i| i.gsub("#{watchdir}/", '')}
      end
    end
    @@listener.start
  end

  def self.work
    worker = Resque::Worker.new '*'
    worker.work 5
  end

  def self.stop
    #  @@listener.stop
  end
end
