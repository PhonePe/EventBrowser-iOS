Pod::Spec.new do |s|
  s.name            = 'EventBrowser'
  s.version         = '1.0.0'
  s.license         = { :type => "MIT", :file => "LICENSE" }
  s.summary         = 'Event Browser'
  s.homepage        = 'https://github.com/PhonePe/EventBrowser'
  s.author          = { 'Srikanth KV' => 'srikanth.gundaz@gmail.com' }
  s.source          = { :git => 'https://github.com/PhonePe/EventBrowser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '17.0'
  
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
    core.source_files = 'EventBrowser/Classes/**/*'
  end
  
  s.subspec 'EventBrowserUI' do |eventBrowserUI|
    eventBrowserUI.source_files = 'EventBrowserUI/Classes/**/*'
    eventBrowserUI.dependency 'EventBrowser/Core'
  end
  
end
