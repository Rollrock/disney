//
//  AppDelegate.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "AppDelegate.h"
#import "YouMiConfig.h"


@implementation AppDelegate

- (void)dealloc
{
    [_locMag release];
    
    [_window release];
    [super dealloc];
}



-(void)initLoacation
{
    _locMag = [[CLLocationManager alloc]init];
    
    if( [_locMag locationServicesEnabled] )
    {
        _locMag.delegate = self;
        _locMag.desiredAccuracy = kCLLocationAccuracyBest;
        _locMag.distanceFilter = 200.0f;
        [_locMag startUpdatingLocation];
    }
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location error!!!");
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = [locations lastObject];
    
    double dLon = location.coordinate.longitude;
    double dLat = location.coordinate.latitude;
    
    _longitude = dLon;
    _latitude = dLat;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainViewController = [[[MainViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    self.window.rootViewController = self.mainViewController;
    
    
    [self initLoacation];
    
    [self.window makeKeyAndVisible];
    
    //[YouMiConfig setUserID:]; // [可选] 例如开发者的应用是有登录功能的，则可以使用登录后的用户账号来替代有米为每台机器提供的标识（有米会为每台设备生成的唯一标识符）。
    //[YouMiConfig setUseInAppStore:YES];  // [可选]开启内置appStore，详细请看YouMiSDK常见问题解答
    
    [YouMiConfig launchWithAppID:@"4a7e95875ecb8c0f" appSecret:@"0a3477b625d69c00"];
    [YouMiConfig setFullScreenWindow:self.window];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
