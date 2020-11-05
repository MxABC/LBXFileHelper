Pod::Spec.new do |s|
s.name         = 'LBXFileHelper'
s.version      = '1.0'
s.summary      = 'iOS FileHelper'
s.homepage     = 'https://github.com/MxABC/LBXFileHelper'
s.license      = 'MIT'
s.authors      = {'lbxia' => 'lbxia20091227@foxmail.com'}
s.source       = {:git => 'https://github.com/MxABC/LBXFileHelper.git', :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'LBXFileHelper/*.{h,m}'
s.frameworks = 'Foundation', 'UIKit'

end

