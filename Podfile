platform :ios, '6.0' 
inhibit_all_warnings! 
xcodeproj 'MyProject' 
pod 'ObjectiveSugar', '~> 0.5' 
target :test do 
pod 'OCMock', '~> 2.0.1'
end 
post_install do |installer
installer.project.targets.each do |target| 
puts "#target.name"
end
end
