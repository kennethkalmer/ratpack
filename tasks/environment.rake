# Figure out our Ruby 1.9 stuff
task :environment do
  # check for 1.9.1 series via multiruby
  output = `multiruby_setup list 2>/dev/null`
  unless $?.success?
    puts 'Ratpack currently depends on multiruby being installed for Ruby 1.9.1 support'
    puts 'Please install multiruby now with "gem install ZenTest"'
    exit 1
  end

  unless output.to_s =~ /1(\.|_)9(\.|_)1/
    puts 'You have multiruby installed, but we cannot find a suitable Ruby 1.9.1'
    puts 'Please install Ruby 1.9.1 by running: multiruby_setup mri:svn:tag:v1_9_1_preview2'
    exit 1
  end

  output.each_line do |l|
    if l =~ /1[\.\_]9[\.\_]1/
      MULTIRUBY_RUBY_VERSION = l.strip
    end
  end

  puts "Using multiruby (#{MULTIRUBY_RUBY_VERSION})"
  ENV['PATH'] = "~/.multiruby/install/#{MULTIRUBY_RUBY_VERSION}/bin:#{ENV['PATH']}"

  RATPACK_BASE = File.dirname(__FILE__) + '/..'
end
