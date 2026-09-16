#import "UnifiedBannerViewController.h"
#import <TANMobSDK/TANMobSDK.h>
#import "AdSurgeMediationAppDelegate.h"

@interface UnifiedBannerViewController () <TANUnifiedBannerAdViewDelegate>
@property (nonatomic, strong) TANUnifiedBannerAdView *bannerView;

@property (weak, nonatomic) IBOutlet UITextField *placementIdText;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UILabel *customWidthLabel;
@property (nonatomic, strong) NSArray *frameArray;
@property (nonatomic, strong) NSArray *widthArray;
@property (nonatomic, strong) NSArray *heightArray;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (weak, nonatomic) IBOutlet UITextField *customWidth;
@property (weak, nonatomic) IBOutlet UITextField *customHeight;
@property (nonatomic, strong) AdLogTable *logTable;
@end

@implementation UnifiedBannerViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusLabel.numberOfLines = 0;
    self.frameArray = @[
        @"320*50",
        @"300*250",
        @"Custom size"
    ];
    self.widthArray = @[@320, @300];
    self.heightArray = @[@50, @250];
    self.width = 320;
    self.height = 50;
    self.placementIdText.placeholder = [self mediationId];
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.logTable) {
        CGRect customHeightFrame = [self.customHeight.superview convertRect:self.customHeight.frame toView:self.view];
        CGFloat topMargin = CGRectGetMaxY(customHeightFrame) - self.view.safeAreaInsets.top;
        CGFloat bottomMargin = self.view.safeAreaLayoutGuide.layoutFrame.size.height * 0.1 * -1;
        self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:topMargin withBottomMargin:bottomMargin];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAdAndShow:(id)sender {
    [self.logTable cleanlogs];
    [self.logTable addLogWithInfo:@"Loading..." ad:nil error:nil status:AdStatusLoading s2sResult:nil];
    if (self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }

    [self.view addSubview:self.bannerView];
    [self setupBannerViewConstraints]; // Set up Auto Layout constraints
    NSLog(@"[AdSurgeMediation_INFO] the banner Ad is start to load and show");
    // Load the first ad
    [self.bannerView loadAdAndShow];
}

- (IBAction)removeAd:(id)sender {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

- (IBAction)changeFrame:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"changeFrame"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < self.frameArray.count; i++) {
        NSString *optionTitle = self.frameArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:optionTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            if (i == self.frameArray.count-1) {
                self.width = [self.customWidth.text integerValue];
                self.height = [self.customHeight.text integerValue];
            } else {
                self.width = [self.widthArray[i] integerValue];
                self.height = [self.heightArray[i] integerValue];
            }
            self.placementIdText.text = @"";
            self.placementIdText.placeholder = [self mediationId];
            
        }];
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    if ([alertController respondsToSelector:@selector(popoverPresentationController)]) {
//        alertController.popoverPresentationController.sourceView = self.view;
//        alertController.popoverPresentationController.sourceRect = self.view.bounds;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)mediationId {
    if (self.width == 300) {
        return @"1000150";
    } else {
        return @"1000149";
    }
}

#pragma mark - property getter
- (TANUnifiedBannerAdView *)bannerView
{
    if (!_bannerView) {
        NSString *placementId = self.placementIdText.text.length > 0 ? self.placementIdText.text: self.placementIdText.placeholder;
        _bannerView = [[TANUnifiedBannerAdView alloc] initWithAdUnitIdentifier:placementId];
        _bannerView.delegate = self;
        _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bannerView;
}

- (void)setupBannerViewConstraints
{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    [NSLayoutConstraint activateConstraints:@[
        // Align to the bottom of safeAreaLayoutGuide to avoid covering the ad/controls above
        [self.bannerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [self.bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bannerView.widthAnchor constraintEqualToConstant:width],
        [self.bannerView.heightAnchor constraintEqualToConstant:height]
    ]];
}

#pragma mark - TANUnifiedBannerAdViewDelegate
/**
 * It is called after the request for AD bar data is successful
 * This function is called when the advertisement data returned by the receiving server is successfully received
 */
- (void)unifiedBannerViewDidLoad:(TANAd *)ad
{
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad load successful", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The banner Ad load was successful\n ad:%@", [ad description]);
    [self.logTable addLogWithInfo:@"Load success" ad:ad error:nil status:AdStatusSuccess s2sResult:nil];
}

/**
 *  It is called after the request for AD bar data fails
 *   This function is called when the advertisement data returned by the receiving server fails
 */
- (void)unifiedBannerViewFailedToLoad:(TANAd *)ad error:(NSError *)error
{
    NSLog(@"[AdSurgeMediation_INFO] The banner Ad load fail: %@", [error localizedDescription]);
    self.statusLabel.text = [error localizedDescription];
    [self.logTable addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Load failed:", self.statusLabel.text] ad:ad error:error status:AdStatusError s2sResult:nil];
}

- (void)unifiedBannerViewFailedToShow:(TANAd *)ad error:(NSError *)error {
    NSLog(@"[AdSurgeMediation_INFO] The banner Ad show fail: %@", [error localizedDescription]);
    self.statusLabel.text = [error localizedDescription];
    [self.logTable addLogWithInfo:[NSString stringWithFormat:@"%@%@", @"Show failed:", self.statusLabel.text] ad:ad error:error status:AdStatusError s2sResult:nil];
}

/**
 *  banner exposure pullback
 */
- (void)unifiedBannerViewWillExpose:(TANAd *)ad {
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad exposed", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The banner Ad will expose.");
    [self.logTable addLogWithInfo:@"Ad exposed" ad:ad error:nil status:AdStatusShowing s2sResult:nil];
}

/**
 *  banner click callback
 */
- (void)unifiedBannerViewClicked:(TANAd *)ad
{
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ad clicked", [ad getNetworkName]];
    NSLog(@"[AdSurgeMediation_INFO] The banner Ad did clicked.");
    [self.logTable addLogWithInfo:@"Ad clicked" ad:ad error:nil status:AdStatusClicked s2sResult:nil];
}
@end


