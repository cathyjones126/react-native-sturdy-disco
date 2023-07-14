require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNSturdyDisco"
  s.version      = package['version'].gsub(/v|-beta/, '')
  s.summary      = package['description']
  s.description  = package['description']
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.author       = package['author']
  
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/cathyjones126/react-native-sturdy-disco.git", :tag => "master" }

  s.source_files = "ios/*.{h,m}"
  s.requires_arc = true
  s.preserve_paths = 'README.md', 'package.json', 'index.js'

  s.dependency 'React'
  s.dependency 'UMAPM'
  s.dependency 'UMCommon'
  s.dependency 'UMDevice'
  s.dependency 'CocoaSecurity'
  s.dependency 'JJException'
  s.dependency 'ReactiveObjC'
  
end

  
