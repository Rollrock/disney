//
//  AppDelegate.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WXApi.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,WXApiDelegate>
{
    CLLocationManager * _locMag;
}

@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double latitude;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController * mainViewController;


-(void) shareWithTextUrl;
-(BOOL)isWeChatValid;

@end
