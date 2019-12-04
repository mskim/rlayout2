# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'
begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'newsman'
  app.frameworks << 'AppKit'
  app.frameworks << 'Quartz'
  app.frameworks << 'CoreGraphics'
  app.frameworks << 'CoreFoundation'
  app.eval_support = true
  app.info_plist['LSUIElement'] = true
  app.deployment_target = "10.14" #build for Lion

  Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each do |file|
    app.files.unshift(file)
  end

end

task :install_app do
  puts "updating newsman.app ..."
  sh "rm -r /Applications/newsman.app" if File.directory?("/Applications/newsman.app")
  sh "cp -r ./build/MacOSX-10.10-Development/newsman.app /Applications/newsman.app"
end
