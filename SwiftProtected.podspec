Pod::Spec.new do |s|
    s.name         = "SwiftProtected"
    s.version      = "0.1.0"
    s.summary      = "Offers the protected modifier to Swift."
    s.homepage     = "https://github.com/scottyelvington/swift-protected"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "Scott Yelvington" => "scottyelvington@gmail.com" }
    s.source       = { :git => "https://github.com/scottyelvington/swift-protected.git", :tag => "#{s.version}" }
    s.swift_version = '5.5'
    s.ios.deployment_target = '13.0'
    s.source_files  = "Sources/SwiftProtected/**/*.{swift}"
  end
  