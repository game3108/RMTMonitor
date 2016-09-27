Pod::Spec.new do |s|  
  s.name             = "RMTMonitor"  
  s.version          = "1.0.0"  
  s.summary          = "A runloop monitor to check ui lag on iOS."  
  s.description      = <<-DESC  
                       It is a runloop monitor to check ui lag on iOS, which implement by Objective-C.  
                       DESC  
  s.homepage         = "https://github.com/game3108/RMTMonitor"  
  s.license          = 'MIT'  
  s.author           = { "game3108" => "game3108@qq.com" }  
  s.source           = { :git => "git@github.com:game3108/RMTMonitor.git", :tag => s.version.to_s }  

  s.platform     = :ios, "7.0"   
  s.requires_arc = true  
  
  s.source_files = "RMTMonitor/*.{h,m}"
end  