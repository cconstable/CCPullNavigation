Pod::Spec.new do |s|
  s.name     = 'CCPullNavigation'
  s.version  = '1.0.0'
  s.summary  = 'This library allows users to navigate views by pulling on a side of a scroll view.'
  s.homepage = 'https://github.com/mstrchrstphr/CCPullNavigation'
  s.author   = 'Christopher Constable'
  s.license   = {
    :type => 'MIT',
    :file => 'LICENSE'
  }

  s.source   = { :git => 'https://github.com/mstrchrstphr/CCPullNavigation.git',
                 :commit => '84699bd9e6860b7adb1ea2a11a725f3db8e2a572' }

  s.platform = :ios
  s.source_files = 'CCPullavigation/**/*.{h,m}'

  s.requires_arc = true

end