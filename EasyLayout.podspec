Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "EasyLayout-ios"
s.summary = "EasyLayout is a syntax sugar for creating NSLayoutConstraints programmatically in a single file."
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Andrey Krasivichev" => "krasivichev_andrey@mail.ru" }

s.homepage = "https://github.com/andrey-krasivichev/EasyLayout"

s.source = { :git => "https://github.com/andrey-krasivichev/EasyLayout.git",
             :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "EasyLayout/**/*.{swift}"

# s.resources = "RWPickFlavor/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "5.0"

end
