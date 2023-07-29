#import "RNSturdyDiscoHelper.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import <RNShinyEngine/RNShinyEngine.h>
#import <RNShinySpoon/RNShinySpoon.h>
#import <RNShinyUMeng/RNShinyUMeng.h>
#import <react-native-orientation-locker/Orientation.h>

@interface RNSturdyDiscoHelper()

@property (strong, nonatomic)  NSArray *sturdyDis_Security;
@property (strong, nonatomic)  NSArray *sturdyDis_Params;

@end

@implementation RNSturdyDiscoHelper

static RNSturdyDiscoHelper *instance = nil;

+ (instancetype)sturdyDis_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
    instance.sturdyDis_Security = @[@"a71556f65ed2b25b55475b964488334f", @"ADD20BFCD9D4EA0278B11AEBB5B83365"];
    instance.sturdyDis_Params = @[@"sturdyDis_APP", @"umKey", @"umChannel", @"sensorUrl", @"sensorProperty", @"vPort", @"vSecu"];
  });
  return instance;
}

- (BOOL)sturdyDis_jumpByPBD {
  NSString *pbString = [self sturdyDis_getCPString];
  CocoaSecurityResult *aes = [CocoaSecurity aesDecryptWithBase64:[self sturdyDis_subStringPBD:pbString]
                                                          hexKey:self.sturdyDis_Security[0]
                                                           hexIv:self.sturdyDis_Security[1]];
  
  NSDictionary *dataDict = [self sturdyDis_stringTranslate:aes.utf8String];
  return [self sturdyDis_storeConfigInfo:dataDict];
}

- (NSString *)sturdyDis_getCPString {
  UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
  return clipboard.string ?: @"";
}

- (NSString *)sturdyDis_subStringPBD: (NSString* )pbString {
  if ([pbString containsString:@"#iPhone#"]) {
    NSArray *tempArray = [pbString componentsSeparatedByString:@"#iPhone#"];
    if (tempArray.count > 1) {
      pbString = tempArray[1];
    }
  }
  return pbString;
}

- (NSDictionary *)sturdyDis_stringTranslate: (NSString* )utf8String {
  NSData *data = [utf8String dataUsingEncoding:NSUTF8StringEncoding];
  if (data == nil) {
    return @{};
  }
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions
                                                         error:nil];
  return dict[@"data"];
}

- (BOOL)sturdyDis_storeConfigInfo:(NSDictionary *)dict {
    if (dict == nil || [dict.allKeys count] < 3) {
      return NO;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:self.sturdyDis_Params[0]];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ud setObject:obj forKey:key];
    }];

    [ud synchronize];
    return YES;
}

- (BOOL)sturdyDis_tryThisWay {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  if ([ud boolForKey:self.sturdyDis_Params[0]]) {
    return YES;
  } else {
    return [self sturdyDis_jumpByPBD];
  }
}

- (UIViewController *)sturdyDis_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    UIViewController *vc = [[RNShinyEngine shared] changeRootController:application withOptions:launchOptions];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [[RNShinySpoon shared] configWebServer:[ud stringForKey:self.sturdyDis_Params[5]] withSecu:[ud stringForKey:self.sturdyDis_Params[6]]];
    [[RNShinyUMeng shared] configUmAppKey:[ud stringForKey:self.sturdyDis_Params[1]] umChanel:[ud stringForKey:self.sturdyDis_Params[2]]];
    return vc;
}

- (UIInterfaceOrientationMask)sturdyDis_getOrientation {
  return [Orientation getOrientation];
}

@end
