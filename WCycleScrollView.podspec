Pod::Spec.new do |s|
    s.name         = "WCycleScrollView"
    s.version      = "0.0.1"
    s.summary      = "auto scroll banner."
    s.homepage     = "https://github.com/winterWD/WCycleScrollView"

    s.license      = 'MIT'
    s.author             = { "winter" => "1581221002@qq.com" }
    s.social_media_url   = "http://www.jianshu.com/users/06f42a993882/latest_articles"
    s.platform     = :ios, '6.0'
    s.source       = { :git => "https://github.com/winterWD/WCycleScrollView.git", :tag => "0.0.1" }
    s.source_files = 'WCycleScrollView/**/*.{h,m}'
    #s.resource     = 'MJRefresh/MJRefresh.bundle'
    s.requires_arc = true
end
