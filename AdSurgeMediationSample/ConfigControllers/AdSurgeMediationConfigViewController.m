#import "AdSurgeMediationConfigViewController.h"
#import <AdSurgeMediationSDK/AdSurgeMediationSDK.h>
#import "UIAlertController+AdSurgeMediationMultiLineTextInput.h"

@interface AdSurgeMediationConfigViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AdSurgeMediationConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

- (void)initData {
    self.data = @[
        @{@"Upload Attribution Info" : @"uploadAttributionInfoStr"},
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.data[indexPath.row].allKeys.firstObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.data[indexPath.row];
    SEL sel = NSSelectorFromString(dic.allValues.firstObject);
    if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
    }
}


- (void)uploadAttributionInfoStr {
    UIAlertController *alertController = [UIAlertController showMultiLineTextInputWithTitle:@"Upload Attribution Info" completion:^(NSString *text) {
            [AdSurgeMediationSDKConfig uploadAttributionInfoStr:text];
        }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
