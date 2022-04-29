//
//  AppDelegate.m
//  AdMobMediation_v8
//
//  Created by JustinTsou on 2021/5/31.
//

#import "AppDelegate.h"
#import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdItemViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    AdItemViewController *vc = [[AdItemViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];

    // Googles Ads SDK init
    
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    //GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"3070c7e9ca9c30099f9384975578dd77"  ];
    
    
    // Aotter SDK init
    
    // Please fill in you ClientId and secret
    [[AotterTrek sharedAPI] initTrekServiceWithClientId:@"21tgwWwuzFYiD4ko5Klr"
                                                 secret:@"fD8P20gzWYrlbuwWklRkicYcNwlWZSZwV+iHj3TzGSzzyfgTWmVR5trs5F1Dp+x9tX2jxq44"
                                          myAppClientId:@"21tgwWwuzFYiD4ko5Klr"
                                      myAppClientSecret:@"fD8P20gzWYrlbuwWklRkicYcNwlWZSZwV+iHj3TzGSzzyfgTWmVR5trs5F1Dp+x9tX2jxq44"
     ];
    
    [[AotterTrek sharedAPI] performSelector:@selector(enableLoggerLevelDevDetail)];
    [[AotterTrek sharedAPI] performSelector:@selector(enableLoggerDevNetwork)];
    
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
