//
//  MyAdmobView.h
//  FirstGame
//
//  Created by zhuang chaoxiao on 14-8-5.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADAdSize.h"

@interface MyAdmobView : UIView<GADBannerViewDelegate>


-(id)initWithViewController:(UIViewController*)vc;

@end
