Pod::Spec.new do |s|

  s.name        = "KeyboardMan"
  s.version     = "1.2.3"
  s.summary     = "KeyboardMan helps you do keyboard animation."

  s.description = <<-DESC
                   We may need keyboard infomation from keyboard notification to do animation.
                   However, the approach is complicated and easy to make mistakes.
                   But KeyboardMan will make it simple & easy.
                   DESC

  s.homepage    = "https://github.com/nixzhu/KeyboardMan"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "nixzhu" => "zhuhongxu@gmail.com" }
  s.social_media_url  = "https://twitter.com/nixzhu"

  s.ios.deployment_target   = "8.0"

  s.source          = { :git => "https://github.com/nixzhu/KeyboardMan.git", :tag => s.version }
  s.source_files    = "KeyboardMan/*.swift"
  s.requires_arc    = true

end
