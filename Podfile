# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'rChile' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for rChile

pod 'Moya/RxSwift', '~> 15.0'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Kingfisher', '~> 7.0'

  target 'rChileTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'rChileUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end
