#import "UIAlertController+AdSurgeMediationMultiLineTextInput.h"

@implementation UIAlertController (AdSurgeMediationMultiLineTextInput)

+ (UIAlertController *)showMultiLineTextInputWithTitle:(NSString *)title completion:(void (^)(NSString *text))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    CGSize size = [UIScreen mainScreen].bounds.size;
    UIViewController *scrollViewController = [[UIViewController alloc] init];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 270, size.height/2.0)];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, alertController.view.frame.size.width - 20, 100)];
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:16];
    
    [scrollView addSubview:textView];
    
    scrollView.contentSize = CGSizeMake(270, textView.frame.size.height + 20);
    [scrollViewController.view addSubview:scrollView];
    scrollViewController.preferredContentSize = scrollView.bounds.size;
    
    [alertController setValue:scrollViewController forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"[AdSurgeMediation_INFO] %@", textView.text);
        if (completion) completion(textView.text);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    return alertController;
}

@end
