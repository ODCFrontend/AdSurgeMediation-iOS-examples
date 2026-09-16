#import "UnifiedInterstitialViewController.h"
#import <TANMobSDK/TANMobSDK.h>

@interface UnifiedInterstitialViewController () <
    TANUnifiedInterstitialAdDelegate>
@property(nonatomic, strong) TANUnifiedInterstitialAd *interstitial;
@property(weak, nonatomic) IBOutlet UILabel *interstitialStateLabel;
@property(weak, nonatomic) IBOutlet UITextField *positionID;
@property(nonatomic, weak) IBOutlet UILabel *adValidLabel;
@property(weak, nonatomic) IBOutlet UIButton *showAdButton;
@property(nonatomic, copy) NSString *placeHolderString;
@property(nonatomic, strong) AdLogTable *logTable;
@end

@implementation UnifiedInterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"UnifiedInterstitial Ad Status";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeHolderString = self.positionID.placeholder;
    self.positionID.placeholder = [self mediationId];
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.logTable) {
        CGRect validFrame = [self.adValidLabel.superview convertRect:self.adValidLabel.frame toView:self.view];
        CGFloat topMargin = CGRectGetMaxY(validFrame) - self.view.safeAreaInsets.top;
        CGFloat bottomMargin = self.view.safeAreaLayoutGuide.layoutFrame.size.height * 0.1 * -1;
        self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:topMargin withBottomMargin:bottomMargin];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAd:(id)sender {
    [self loadAd];
}

- (void)loadAd {
    [self.logTable cleanlogs];
    [self.logTable addLogWithInfo:@"Loading..."
                               ad:nil
                            error:nil
                           status:AdStatusLoading
                        s2sResult:nil];
    self.adValidLabel.text = @"";
    if (self.interstitial) {
        self.interstitial.delegate = nil;
    }
    NSString *placmentId = self.positionID.text.length > 0
    ? self.positionID.text
    : self.positionID.placeholder;
    self.interstitial =
    [[TANUnifiedInterstitialAd alloc] initWithPlacementId:placmentId];
    self.interstitial.delegate = self;
    NSLog(@"[AdSurgeMediation_INFO] the interstitial Ad is start to load.");
    [self.interstitial loadAd];
}

- (IBAction)showAd:(id)sender {
    if (!self.interstitial) {
        [self.logTable addLogWithInfo:@"Show failed:" ad:nil error:[TANAdErrors errorWithCode:-1 description:@"Please load AD"] status:AdStatusError s2sResult:nil];
        return;
    }
    if ([self.interstitial showAdFromRootViewController:self]) {
        NSLog(@"[AdSurgeMediation_INFO] the interstitial Ad is start to show.");
    } else {
        self.interstitialStateLabel.text = @"Invalid Ad Data";
    }
}

- (IBAction)checkAdValidation:(id)sender {
    self.adValidLabel.text =
    [self.interstitial isAdValid] ? @"Valid AD" : @"Invalid AD";
    NSLog(@"[AdSurgeMediation_INFO] the interstitial Ad is %@.",
          self.adValidLabel.text);
}

- (NSString *)mediationId {
    return @"1000148";
}

#pragma mark - TANUnifiedInterstitialAdDelegate

/**
 *  Callback for successful preloading of interstitial ads
 *  This function is called when the advertisement data returned by the
 * receiving server is successfully received
 */
- (void)unifiedInterstitialSuccessToLoadAd:(TANAd *)ad {
    self.interstitialStateLabel.text =
    [NSString stringWithFormat:@"%@:%@ %@", INTERSTITIAL_STATE_TEXT,
     [ad getNetworkName], @"Load Success."];
    NSLog(@"[AdSurgeMediation_INFO] The interstitial Ad load was successful\n "
          @"ad:%@",
          [ad description]);
    [self.logTable addLogWithInfo:@"Load success"
                               ad:ad
                            error:nil
                           status:AdStatusSuccess
                        s2sResult:nil];
}

/**
 *   Callback for failed preloading of interstitial ads
 *   This function is called when the advertisement data returned by the
 * receiving server fails
 */
- (void)unifiedInterstitialFailToLoadAd:(TANAd *)ad error:(NSError *)error {
    NSLog(@"[AdSurgeMediation_INFO] The interstitial Ad load fail: %@.",
          [error localizedDescription]);
    self.interstitialStateLabel.text =
        [NSString stringWithFormat:@"%@:%@,Error : %@", INTERSTITIAL_STATE_TEXT,
                                   @"Fail Loaded.", error];
    [self.logTable
        addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Load failed:",
                                                  [error localizedDescription]]
                    ad:ad
                 error:error
                status:AdStatusError
             s2sResult:nil];
}

- (void)unifiedInterstitialFailToShowAd:(TANAd *)ad error:(NSError *)error {
    NSLog(@"[AdSurgeMediation_INFO] The interstitial Ad show fail: %@.",
          [error localizedDescription]);
    self.interstitialStateLabel.text =
        [NSString stringWithFormat:@"%@:%@,Error : %@", INTERSTITIAL_STATE_TEXT,
                                   @"Show Fail.", error];
    [self.logTable
        addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Show failed:",
                                                  [error localizedDescription]]
                    ad:ad
                 error:error
                status:AdStatusError
             s2sResult:nil];
}

/**
 *  Interstitial AD exposure pullback
 */
- (void)unifiedInterstitialWillExposure:(TANAd *)ad {
    NSLog(@"[AdSurgeMediation_INFO] The interstitial Ad will expose.");
    [self.logTable addLogWithInfo:@"Ad exposed"
                               ad:ad
                            error:nil
                           status:AdStatusShowing
                        s2sResult:nil];
}

/**
 *  Click callback for interstitial ads
 */
- (void)unifiedInterstitialClicked:(TANAd *)ad {
    NSLog(@"[AdSurgeMediation_INFO] The interstitial Ad did clicked.");
    [self.logTable addLogWithInfo:@"Ad clicked"
                               ad:ad
                            error:nil
                           status:AdStatusClicked
                        s2sResult:nil];
}

/**
 *  The full-screen advertisement page has been closed
 */
- (void)unifiedInterstitialAdDidClose:(TANAd *)ad {
    NSLog(@"[AdSurgeMediation_INFO] The interstitial Ad did closed.");
    [self.logTable addLogWithInfo:@"Ad did closed"
                               ad:ad
                            error:nil
                           status:AdStatusClosed
                        s2sResult:nil];
}

@end
