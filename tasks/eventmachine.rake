require 'fileutils'

namespace :eventmachine do

  desc "Install the latest (edge) eventmachine gem (requires git)"
  task :install => :environment do
    FileUtils.mkdir( 'tmp2' ) unless File.directory?( 'tmp2' )
    FileUtils.cd( 'tmp2' ) do
      sh "rm -rf eventmachine 2>/dev/null"
      sh "git clone git://github.com/eventmachine/eventmachine"
      FileUtils.cd('eventmachine') do
        sh "gem build eventmachine.gemspec"
        gem_name = Dir['*.gem'].first
        sh "gem install #{gem_name}"
      end
    end
  end
end
