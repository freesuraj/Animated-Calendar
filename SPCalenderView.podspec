Pod::Spec.new do |spec|
  spec.name             = 'SPCalendarView'
  spec.version          = '1.1'
  spec.platform         = :ios
  spec.platform         = :ios, "5.0"
  spec.license          = { :type => "MIT", :file => "LICENSE" }
  spec.homepage         = 'https://github.com/freesuraj/Animated-Calendar.git/'
  spec.screenshots      = "http://i.giphy.com/5xtDarH4Y5ehr0tKGju.gif"
  spec.author           = {'Suraj Pathak' => 'freesuraj@gmail.com'}
  spec.social_media_url = "http://twitter.com/freesuraj"
  spec.summary          = 'A clone of animated calendar similar to the one used in Band of the day app'
  spec.source           = {:git => 'https://github.com/freesuraj/Animated-Calendar.git', :tag => 'v1.1'} 
  spec.source_files     = 'BOD/BOD/SPCalendarView/*.{h,m}'
  spec.frameworks       = "CoreGraphics", "UIKit", "Foundation", "QuartzCore"
  spec.requires_arc     = true
end