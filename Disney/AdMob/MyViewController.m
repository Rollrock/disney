//
//  MyViewController.m
//  AdmoDemo
//
//  Created by zhuang chaoxiao on 13-11-9.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "MyViewController.h"
#import "GADBannerView.h"

@interface MyViewController ()
{
    GADBannerView *bannerView_; 
}
@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    banner = [[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    banner.adUnitID = @"a1527e3f3d6c7bc";
    banner.rootViewController = self;
    [self.view addSubview:banner];
    [banner loadRequest:[GADRequest request]];
     */
    /*
    AdMobView *ad = [AdMobView requestAdWithDelegate:self];
    ad.frame = CGRectMake(0, 432, 320, 48); // 屏幕底部一个320x48的框架
    [self.window addSubview:ad]; // 把这个view加入到window的subviews里面
    */
    
    // Create a view of the standard size at the bottom of the screen.
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            10,
                                            320,
                                            50)];//设置位置
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a1527e3f3d6c7bc";//调用你的id
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];//添加bannerview到你的试图
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];

    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
