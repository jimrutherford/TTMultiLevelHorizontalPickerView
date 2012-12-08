Pod::Spec.new do |s|
  s.name         = "TTMultiLevelHorizontalPickerView"
  s.version      = "0.0.2"
  s.summary      = "A multi-level horizontal picker view that mimics the features found in Apple's Podcast app."
  s.homepage     = "https://github.com/jimrutherford/TTMultiLevelHorizontalPickerView"
  s.license      = {
    :type => 'MIT',
    :text => <<-LICENSE
              Copyright (C) 2012 Braxio Interactive

              All rights reserved.

              Redistribution and use in source and binary forms, with or without
    LICENSE
  }
  s.author       = { "Jim Rutherford" => "jim.rutherford@gmail.com" }
  s.source       = { :git => "https://github.com/jimrutherford/TTMultiLevelHorizontalPickerView.git", :commit => "03eceebcd93c5e71977a33c2bb42356015539f25" }
  s.platform     = :ios
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.requires_arc = true
end
