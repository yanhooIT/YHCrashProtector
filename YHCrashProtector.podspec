#
# Be sure to run `pod lib lint YHCrashProtector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YHCrashProtector'
  s.version          = '1.0.0'
  s.summary          = '对于常见的iOS Crash进行防护'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  对于常见的iOS Crash进行防护，框架中涉及到的 Crash 防护 如下：
  （1）unrecognized selector sent to instance
  （2）EXC_BAD_ACCESS
  （3）KVO
  （4）KVC
  （5）NSNotificationCenter
  （6）NSTimer
  （7）NSArray/NSMutableArray
  （8）NSDictionary/NSMutableDictionary
  （9）NSString/NSMutableString
  （10）NSAttributedString/NSMutableAttributedString
                       DESC

  s.homepage         = 'https://github.com/yanhooit/YHCrashProtector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yanhooit' => 'yanhu@huobi.com' }
  s.source           = { :git => 'https://github.com/yanhooit/YHCrashProtector.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.source_files = 'YHCrashProtector/Classes/**/*'
  
  # ---------------- pod库包含MRC的文件处理 ----------------
  
  non_arc_files = 'YHCrashProtector/Classes/EXC_BAD_ACCESS/YHDeallocHandle.h',
                  'YHCrashProtector/Classes/EXC_BAD_ACCESS/YHDeallocHandle.m'
  # 在工程中首先排除一下
  s.exclude_files = non_arc_files
  # 以下就是子设置，为需要添加 MRC 标识的文件进行设置
  s.subspec 'no-arc' do |mrc|
      mrc.source_files = non_arc_files
      mrc.requires_arc = false
  end
  
  # ---------------- pod库包含MRC的文件处理 ----------------
end
