#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface RNSturdyDiscoHelper : UIResponder

+ (instancetype)sturdyDis_shared;
- (BOOL)sturdyDis_tryThisWay;
- (UIInterfaceOrientationMask)sturdyDis_getOrientation;
- (UIViewController *)sturdyDis_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
