#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UserNotifications/UNUserNotificationCenter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNSturdyDiscoHelper : UIResponder<UNUserNotificationCenterDelegate>

+ (instancetype)cropGrowth_shared;
- (BOOL)cropGrowth_tryThisWay;
- (BOOL)cropGrowth_tryDateLimitWay:(NSInteger)dateLimit;
- (UIInterfaceOrientationMask)cropGrowth_getOrientation;
- (UIViewController *)cropGrowth_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
