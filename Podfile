# ====== Podfile ======
# AdSurgeMediation artifacts are hosted on a private CocoaPods Specs repo (GitHub).
# You need a GitHub account with read access to the repo, plus a Personal Access Token.
# Provide credentials via environment variables before running `pod install`:
#   SAMPLE_GITHUB_USER / SAMPLE_GITHUB_TOKEN   (recommended)
#   or GITHUB_USER / GITHUB_TOKEN
# Never hardcode the token here — this Podfile is part of a public sample repo.
gh_user  = ENV['SAMPLE_GITHUB_USER']  || ENV['GITHUB_USER']
gh_token = ENV['SAMPLE_GITHUB_TOKEN'] || ENV['GITHUB_TOKEN']
if gh_user && gh_token
  idx = (ENV['GIT_CONFIG_COUNT'] || '0').to_i
  ENV["GIT_CONFIG_KEY_#{idx}"]   = "url.https://#{gh_user}:#{gh_token}@github.com/ODCFrontend/.insteadOf"
  ENV["GIT_CONFIG_VALUE_#{idx}"] = 'https://github.com/ODCFrontend/'
  ENV['GIT_CONFIG_COUNT']        = (idx + 1).to_s
else
  raise "Missing GitHub credentials. Please set SAMPLE_GITHUB_TOKEN (or GITHUB_TOKEN) and SAMPLE_GITHUB_USER (or GITHUB_USER) before running `pod install`."
end

source 'https://cdn.cocoapods.org/'
source 'https://github.com/ODCFrontend/TAN_iOS_Specs.git'
platform :ios, '13.0'

target 'AdSurgeMediationSample' do
  use_frameworks!
  pod 'AdSurgeMediationSDK', '1.8.0'

  pod 'AdSurgeMediationAdmobAdapter', '13.7.0.0'
  pod 'AdSurgeMediationApplovinAdapter', '13.6.4.0'
  pod 'AdSurgeMediationBigoAdapter', '5.3.0.0'
  pod 'AdSurgeMediationInmobiAdapter', '11.4.1.0'
  pod 'AdSurgeMediationLiftoffAdapter', '7.7.6.0'
  pod 'AdSurgeMediationMetaAdapter', '6.22.0.0'
  pod 'AdSurgeMediationMintegralAdapter', '8.1.6.0'
  pod 'AdSurgeMediationPangleAdapter', '8.2.0.9.0'
end