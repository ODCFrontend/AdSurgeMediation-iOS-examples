#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdSurgeMediationAdViewController : UIViewController

typedef NSDictionary<NSString *, Class> AdRow;
typedef NSArray<AdRow *> AdRows;
typedef NSDictionary<NSString *, AdRows *> AdSection;
@property (nonatomic, strong) NSArray<AdSection *> *demoArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *navLeftButton;
@end

NS_ASSUME_NONNULL_END
