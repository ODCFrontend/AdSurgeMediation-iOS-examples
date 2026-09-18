# AdSurgeMediation iOS Sample (Objective-C)

An official sample project for developers, demonstrating how to integrate the AdSurgeMediation SDK (formerly known as TAN, Serafino) and call its ad formats.

## Features

- SDK initialization (`AdSurgeMediationAdViewController`, "InitSDK" button)
- Rewarded video (`RewardVideoViewController`)
- Interstitial (`UnifiedInterstitialViewController`)
- Banner (320x50) / MREC (300x250) with runtime format switch (`UnifiedBannerViewController`)
- Attribution info reporting (`AdSurgeMediationSDKConfig uploadAttributionInfoStr:`, on `AdSurgeMediationConfigViewController`)
- Integrated with AdMob as a sample ADN

## Project Structure

```text
AdSurgeMediationSample/
├── AdSurgeMediationAppDelegate.h/.m         App entry point
├── AdSurgeMediationNavigationController.h/.m
├── AdSurgeMediationAdViewController.h/.m    Home screen: SDK initialization + ad format list
├── AdSurgeMediationAds/                     Ad format sample view controllers
│   ├── AdSurgeMediationRewardVideoAd/
│   ├── AdSurgeMediationUnifiedInterstitialAd/
│   └── AdSurgeMediationUnifiedBannerAd/
├── ConfigControllers/                       Attribution info reporting sample
└── Supporting Files/                        Info.plist, Launch Screen, main.m
```

## Dependency Setup

AdSurgeMediation artifacts are hosted on a private CocoaPods Specs repo (GitHub). You need a GitHub account with read access to the repository, plus a Personal Access Token.
You can obtain these from the platform: https://www.adsurge.com/mediation/sdk_download

Before running `pod install`, set the following environment variables:

```bash
export SAMPLE_GITHUB_USER=<your-github-username>
export SAMPLE_GITHUB_TOKEN=<your-personal-access-token>
```

(`GITHUB_USER` / `GITHUB_TOKEN` are also accepted as a fallback.) Never hardcode credentials into the `Podfile`.

Then install pods and open the workspace:

```bash
pod install
open AdSurgeMediationSample.xcworkspace
```

> Always open `AdSurgeMediationSample.xcworkspace`, not the `.xcodeproj` directly — the app depends on CocoaPods (`use_frameworks!`) to link the SDK and adapters.

## Configure Ad Parameters

Fill in your own App ID and ad unit IDs (obtained from the AdSurgeMediation dashboard):

| Parameter | File | Location |
|---|---|---|
| App ID | `AdSurgeMediationAdViewController.m` | `[AdSurgeMediationSDKConfig initWithAppId:@"..."]` |
| Rewarded ad unit ID | `AdSurgeMediationAds/AdSurgeMediationRewardVideoAd/RewardVideoViewController.xib` | text field `placeholder` |
| Interstitial ad unit ID | `AdSurgeMediationAds/AdSurgeMediationUnifiedInterstitialAd/UnifiedInterstitialViewController.m` | `- (NSString *)mediationId` |
| Banner (320x50) / MREC (300x250) ad unit ID | `AdSurgeMediationAds/AdSurgeMediationUnifiedBannerAd/UnifiedBannerViewController.m` | `- (NSString *)mediationId` |

You can also override any of these directly in the app's placement ID input field at runtime.
