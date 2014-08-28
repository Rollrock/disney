//
//  FirstViewController.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TourDetailViewController.h"
#import "dataStruct.h"

@interface ThirdViewController : UIViewController
{
    UITableView * _tabView;
    NSMutableData * _data;
    NSURLConnection * _conn;
}

@end
