#import "AdSurgeMediationAdViewController.h"
#import "RewardVideoViewController.h"
#import "UnifiedInterstitialViewController.h"
#import "UnifiedBannerViewController.h"
#import "AdSurgeMediationConfigViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AdSurgeMediationSDK/AdSurgeMediationSDK.h>

@interface AdSurgeMediationAdViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSUInteger hiddenTag;
@end

@implementation AdSurgeMediationAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navLeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.navLeftButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/5, 44);
    [self.navLeftButton setTitle:@"InitSDK" forState:UIControlStateNormal];
    [self.navLeftButton setTintColor:[UIColor whiteColor]];
    [self.navLeftButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.navLeftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navLeftButton addTarget:self action:@selector(initAdSurgeMediationSDK) forControlEvents:UIControlEventTouchUpInside];
    self.navLeftButton.accessibilityIdentifier = @"Init_button";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftButton];
    
    UIButton *att = [UIButton buttonWithType:UIButtonTypeSystem];
    att.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/5, 44);
    [att setTitle:@"requestATT" forState:UIControlStateNormal];
    [att setTintColor:[UIColor whiteColor]];
    att.titleLabel.font = [UIFont systemFontOfSize:14];
    [att addTarget:self action:@selector(requestATT) forControlEvents:UIControlEventTouchUpInside];
    att.accessibilityIdentifier = @"ATT_button";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:att];
    
    self.navigationItem.title = [NSString stringWithFormat:@"SDK Ver: %@",[AdSurgeMediationSDKConfig sdkVersion]];
    [self initData];
    [self.view addSubview:self.tableView];
    self.hiddenTag = 0;
    self.tableView.frame = self.view.bounds;
    self.tableView.rowHeight = 56;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)requestATT {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSString *statusString = @"";
            switch (status) {
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    statusString = @"NotDetermined";
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    statusString = @"Restricted";
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                    statusString = @"Denied";
                    break;
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    statusString = @"Authorized";
                    break;
                default:
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *advertisingIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                UIAlertController *alertController = [AdSurgeMediationAlertPresenter showText:[NSString stringWithFormat:@"ATTrackingStatus: \n    %@\n\n IDFA: \n %@\n",statusString,advertisingIdentifier] withConfirmHandler:^(UIAlertAction * _Nonnull action) {
                }];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }];
    }
}

- (void)initData {
    self.demoArray = @[
        @{@"AD Formats":
              @[
                  @{@"Reward Video" : [RewardVideoViewController class]},
                  @{@"Interstitial AD" : [UnifiedInterstitialViewController class]},
                  @{@"Banner AD" : [UnifiedBannerViewController class]},
              ],
        },
        @{@"Settings":
              @[
                  @{@"Upload Attribution Info" : [AdSurgeMediationConfigViewController class]},
              ],
        },
    ];
}

- (void)sectionAction:(UITapGestureRecognizer *)ges {
    NSInteger tag = 1 << ges.view.tag;
    self.hiddenTag = self.hiddenTag ^ tag;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ges.view.tag] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.demoArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AdSection *secInfo = self.demoArray[section];
    NSString *title = secInfo.allKeys.firstObject;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    label.text = [NSString stringWithFormat:@"  %@",title];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.tag = section;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionAction:)];
    [label addGestureRecognizer:ges];
    label.userInteractionEnabled = YES;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tag = 1 << section;
    BOOL isHidden = (self.hiddenTag & tag) != 0;
    if (isHidden) {
        return 0;
    } else {
        AdSection *secInfo = self.demoArray[section];
        AdRows *rowsInfo = (AdRows *)secInfo.allValues.firstObject;
        return rowsInfo.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    AdSection *secInfo = self.demoArray[indexPath.section];
    AdRows *rowsInfo = (AdRows *)secInfo.allValues.firstObject;
    AdRow *row = rowsInfo[indexPath.row];
    cell.textLabel.text = row.allKeys.firstObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdSection *secInfo = self.demoArray[indexPath.section];
    AdRows *rowsInfo = (AdRows *)secInfo.allValues.firstObject;
    AdRow *row = rowsInfo[indexPath.row];
    UIViewController *vc = [[row.allValues.firstObject alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}

- (void)initAdSurgeMediationSDK {
    // Initialize the SDK
    BOOL result = [AdSurgeMediationSDKConfig initWithAppId:@"2081917169595068416"];
    if (result) {
        NSLog(@"[AdSurgeMediation_INFO] =====AdSurgeMediationSample initialized successfully=====");
    }
    // Start the SDK
    __weak typeof(self) weakSelf = self;
    [AdSurgeMediationSDKConfig startWithCompletionHandler:^(BOOL success, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [strongSelf.navLeftButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
                NSLog(@"[AdSurgeMediation_INFO] =====AdSurgeMediationSample started successfully=====");
            } else {
                [strongSelf.navLeftButton setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
                NSLog(@"startWithCompletionHandler errorCode: %ld, errorMsg: %@", error.code, error.userInfo.description);
                // Show an alert with detailed error info when startup fails
                NSString *errormsg = [NSString stringWithFormat:@"errorCode: %ld\nerrorMsg: %@",error.code,error.localizedDescription];
                void (^confirmHandler)(UIAlertAction *) = ^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                };
                UIAlertController *alertController = [AdSurgeMediationAlertPresenter showText: errormsg withConfirmHandler:confirmHandler];
                [strongSelf presentViewController:alertController animated:YES completion:nil];
            }
        });
    } adnInitCompletionHandler:^(NSArray<NSString *> *succeededAdnNames) {
        NSString *successList = succeededAdnNames.count > 0 ? [succeededAdnNames componentsJoinedByString:@", "] : @"None";
        NSLog(@"[AdSurgeMediation_INFO] ADN initialization completed, succeeded ADNs: %@", successList);
    }];
}

@end
