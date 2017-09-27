Pod::Spec.new do |spec|
  spec.name = "StroachTabBar_iOS"
  spec.version = "1.0.2"

  spec.homepage = "https://github.com/lukastruemper/StroachTabBar_iOS"
  spec.summary = "A modern TabBar written in Swift."

  spec.author = { "Lukas Trümper" => "lukas.truemper@outlook.de" }
  spec.license = { :type => "MIT", :file => "LICENSE" }

  spec.platform = :ios, '10.3'
  spec.ios.deployment_target = '10.3'

  spec.source = { :git => "https://github.com/lukastruemper/StroachTabBar_iOS.git", :tag => 'v1.0.2' }

  spec.source_files = "StroachTabBar_iOS/*.swift"
end
