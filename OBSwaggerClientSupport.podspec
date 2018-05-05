Pod::Spec.new do |s|
  s.name             = 'OBSwaggerClientSupport'
  s.version          = '0.1.0'
  s.summary          = 'A support module for Swagger Codegen client code.'

  s.homepage         = 'https://github.com/arthurgau0419/OBSwaggerClientSupport'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'arthurgau0419@gmail.com' => 'arthurgau0419@gmail.com' }
  s.source           = { :git => 'https://github.com/arthurgau0419/OBSwaggerClientSupport.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Arthurgau'

  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'SwaggerClientSupport/Sources/**/*'
  end

  s.subspec 'Promise' do |ss|
    ss.source_files = 'SwaggerClientSupport/Extensions/Promise/Sources/*'
    ss.dependency 'OBSwaggerClientSupport/Core'
    ss.dependency 'PromiseKit'
  end

  s.subspec 'RxSwift' do |ss|
    ss.source_files = 'SwaggerClientSupport/Extensions/RxSwift/Sources/*'
    ss.dependency 'OBSwaggerClientSupport/Core'
    ss.dependency 'RxSwift'
  end

  s.default_subspecs = ['Core']
  s.swift_version = '4.1'
end
