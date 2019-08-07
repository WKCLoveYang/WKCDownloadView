Pod::Spec.new do |s|
s.name         = "WKCDownloadView"
s.version      = "1.1.0"
s.summary      = "WKCDownloadView is a view for download then read the download compents."
s.homepage     = "https://github.com/WKCLoveYang/WKCDownloadView.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCDownloadView.git", :tag => "1.1.0" }
s.source_files  = "WKCDownloadView/**/*.{h,m}"
s.public_header_files = "WKCDownloadView/**/*.h"
s.frameworks = "Foundation", "UIKit"
s.requires_arc = true
s.dependency "AFNetworking"
s.dependency "SSZipArchive"

end
