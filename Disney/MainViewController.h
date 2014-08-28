//
//  MainViewController.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tabbarView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "CenterViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface MainViewController : UIViewController
{
    tabbarView * _tabbarView;
    FirstViewController * _firstViewC;
    SecondViewController * _secondViewC;
    CenterViewController * _centerViewC;
    ThirdViewController * _thirdViewC;
    FourthViewController * _fourthViewC;
    
    UINavigationController * _firstNav;
    UINavigationController * _secondNav;
    UINavigationController * _centerNav;
    UINavigationController * _thirdNav;
    UINavigationController * _fourthNav;
}


@end
