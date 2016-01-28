Pod::Spec.new do |s|
  s.name             = "RoundDropMenu"
  s.version          = "1.0.1"
  s.summary          = "Simple menu written on Swift that ideally suits small sets of visual data."

  s.description      = <<-DESC
  "Simple highly customizable iOS component written in Swift gives you another way to represent data. Round-Drop-Menu is great for small sets of visual information."
                       DESC

  s.homepage         = "https://github.com/burntheroad/RoundDropMenu"
  s.screenshots      = "https://camo.githubusercontent.com/c15a3487eec988653ac84155257f7490275acc98/687474703a2f2f692e696d6775722e636f6d2f674a4c446d41502e676966"
  s.license          = 'MIT'
  s.author           = { "burntheroad" => "gibslp69@gmail.com" }
  s.source           = { :git => "https://github.com/burntheroad/RoundDropMenu.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/monkey_has_gone'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'RoundDropMenu' => ['Pod/Assets/*.png']
  }

end
