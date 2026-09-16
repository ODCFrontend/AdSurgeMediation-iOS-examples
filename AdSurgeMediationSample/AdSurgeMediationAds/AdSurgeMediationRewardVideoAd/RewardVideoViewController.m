#import "RewardVideoViewController.h"
#import "AdSurgeMediationAppDelegate.h"
#import <TANMobSDK/TANMobSDK.h>


@interface RewardVideoViewController () <TANRewardedVideoAdDelegate, UITextFieldDelegate>

@property (nonatomic, strong) TANRewardVideoAd *rewardVideoAd;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkAdButton;
@property (nonatomic, strong) AdLogTable *logTable;

@end

@implementation RewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placementIdTextField.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.logTable) {
        CGRect validFrame = [self.validLabel.superview convertRect:self.validLabel.frame toView:self.view];
        CGFloat topMargin = CGRectGetMaxY(validFrame) - self.view.safeAreaInsets.top;
        CGFloat bottomMargin = self.view.safeAreaLayoutGuide.layoutFrame.size.height * 0.1 * -1;
        self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:topMargin withBottomMargin:bottomMargin];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)loadAd:(id)sender {
    [self.logTable cleanlogs];
    [self.logTable addLogWithInfo:@"Loading..." ad:nil error:nil status:AdStatusLoading s2sResult:nil];
    self.statusLabel.text = @"loading";
    self.validLabel.text = @"";
    NSString *placementId = self.placementIdTextField.text.length > 0 ?self.placementIdTextField.text: self.placementIdTextField.placeholder;
    self.rewardVideoAd = [[TANRewardVideoAd alloc] initWithPlacementId:placementId];
    
    self.rewardVideoAd.delegate = self;
    NSLog(@"[AdSurgeMediation_INFO] the reward Ad is start to load");
    [self.rewardVideoAd loadAd];
}

- (IBAction)playVideo:(UIButton *)sender {
    if (!self.rewardVideoAd) {
        [self.logTable addLogWithInfo:@"Show failed:" ad:nil error:[TANAdErrors errorWithCode:-1 description:@"Please load AD"] status:AdStatusError s2sResult:nil];
        return;
    }
    if ([self.rewardVideoAd showAdFromRootViewController:self]) {
        NSLog(@"[AdSurgeMediation_INFO] the reward Ad is start to show");
    } else {
        self.statusLabel.text = @"The AD is invalid, please reload AD";
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (IBAction)checkAdValidation:(id)sender {
    BOOL adValid = [self.rewardVideoAd isAdValid];
    self.validLabel.text = adValid ? @"current ad is valid" : @"current ad is invalid";
    NSLog(@"[AdSurgeMediation_INFO] the reward Ad %@", self.validLabel.text);
}

#pragma mark - TANRewardedVideoAdDelegate
- (void)tan_rewardVideoAdDidLoad:(TANAd *)ad
{
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad load successful", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad load was successful\n ad:%@", [ad description]);
    [self.logTable addLogWithInfo:@"Load success" ad:ad error:nil status:AdStatusSuccess s2sResult:nil];
}


- (void)tan_rewardVideoAdDidExposed:(TANAd *)ad
{
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad exposed", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad did exposed");
    [self.logTable addLogWithInfo:@"Ad exposed" ad:ad error:nil status:AdStatusShowing s2sResult:nil];
}

- (void)tan_rewardVideoAdDidClose:(TANAd *)ad
{
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad closed", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad did closed");
    [self.logTable addLogWithInfo:@"Ad closed" ad:ad error:nil status:AdStatusClosed s2sResult:nil];
}


- (void)tan_rewardVideoAdDidClicked:(TANAd *)ad
{
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad clicked", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad did clicked");
    [self.logTable addLogWithInfo:@"Ad clicked" ad:ad error:nil status:AdStatusClicked s2sResult:nil];
}

- (void)tan_rewardVideoAdFailToLoadAd:(TANAd *)ad error:(NSError *)error
{
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad load fail: %@", [error localizedDescription]);
    self.statusLabel.text = [error localizedDescription];
    [self.logTable addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Load failed:", self.statusLabel.text] ad:ad error:error status:AdStatusError s2sResult:nil];
}

- (void)tan_rewardVideoAdFailToShowAd:(TANAd *)ad error:(NSError *)error {
    self.statusLabel.text = [error localizedDescription];
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad show fail: %@", [error localizedDescription]);
    [self.logTable addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Show failed:", self.statusLabel.text] ad:ad error:error status:AdStatusError s2sResult:nil];
}

- (void)tan_rewardVideoAdDidRewardEffective:(TANAd *)ad info:(NSDictionary *)info {
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad meets the reward condition, transid:%@", [info objectForKey:@"TAN_TRANS_ID"]);
    [self.logTable addLogWithInfo:@"Reward earned" ad:ad error:nil status:AdStatusSuccess s2sResult:nil];
}

- (void)tan_rewardVideoAdRewardEarnFailed:(TANAd *)ad error:(NSError *)error {
    self.statusLabel.text = [error localizedDescription];
    NSLog(@"[AdSurgeMediation_INFO] The rewarded Ad reward earn failed: %@", [error localizedDescription]);
    [self.logTable addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Reward earn failed:", self.statusLabel.text] ad:ad error:error status:AdStatusError s2sResult:nil];
}

@end
