Pod::Spec.new do |spec|
  spec.name = 'TapLabel'
  spec.version = '0.0.2'
  spec.summary = 'Add links and actions to UILabel.'
  spec.homepage = 'https://github.com/d6u/TapLabel'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Daiwei Lu' => 'daiweilu123@gmail.com' }
  spec.source = { :git => 'https://github.com/d6u/TapLabel.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Source/**/*.{h,swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
end
