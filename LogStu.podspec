Pod::Spec.new do |s|
	s.name		 = "LogStu"
	s.version	 = "2.2.1"
	s.license    = { :type => "MIT" }
	s.homepage   = "https://www.jasnstu.com"
	s.author     = { "jasnstu" => "LogStu@jasnstu.com"}
	s.summary	 = "An simple logging framework for Swift"
	s.source	 = { :git => "https://github.com/jasnstu/LogStu.git", :tag => "v2.1.0" }
	s.swift_version = '5.0'

	s.ios.deployment_target = "8.0"
	s.osx.deployment_target = "10.9"
	s.tvos.deployment_target = "9.0"
	s.watchos.deployment_target = "2.0"

	s.source_files = "Source/**/*.{swift, h}"

	s.requires_arc = true
end
