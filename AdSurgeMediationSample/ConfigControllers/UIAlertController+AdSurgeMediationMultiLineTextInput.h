#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (AdSurgeMediationMultiLineTextInput)

+ (UIAlertController *)showMultiLineTextInputWithTitle:(NSString *)title completion:(void (^)(NSString *text))completion;

@end

NS_ASSUME_NONNULL_END
