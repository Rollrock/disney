//
//  AboutUsViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-29.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "AboutUsViewController.h"
#import "GADBannerView.h"
#import "YouMiWall.h"
#import "dataStruct.h"

@interface AboutUsViewController ()
{
    GADBannerView *_bannerView;
    UIView * _adVgView;
}

@end

@implementation AboutUsViewController

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
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
    
    [self layoutView];
    
    [self laytouADVView];
    
    self.view.backgroundColor = [UIColor grayColor];
}





-(void)laytouADVView
{
    
    _bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0.0,0,320,100)];//设置位置
    
    _bannerView.adUnitID = ADMOB_ID;//调用你的id
 
    _bannerView.rootViewController = self;
    
    _adVgView = [[UIView alloc]initWithFrame:CGRectMake(0.0,0,320,100)];
    [self.view addSubview:_adVgView];
    
    [_adVgView addSubview:_bannerView];//添加bannerview到你的试图
    
    [_bannerView loadRequest:[GADRequest request]];
    
    
    [self showADVAnmi:YES];

}

-(void)layoutView
{
    #define IMAGE_WIDTH_LOCAL 100.0f
    #define IMAGE_HEIGHT_LOCAL 100.0f
    
    CGRect rect = CGRectMake(320/2-IMAGE_WIDTH_LOCAL/2, 10, IMAGE_WIDTH_LOCAL, IMAGE_HEIGHT_LOCAL);
    
    UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    imgView.image = [UIImage imageNamed:@"icon"];
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    
    [self.view addSubview:imgView];
    
    rect = CGRectMake(60, 30+100, 280, 200);
    UIImageView * imgBg = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    //imgBg.image = [UIImage imageNamed:@"about_connect_bg"];
    
    rect = CGRectMake(5, 10, 270, 20);
    UILabel * labName = [[[UILabel alloc]initWithFrame:rect]autorelease];
    labName.text = @"联系人:   小土豆";
    labName.backgroundColor = [UIColor clearColor];
    [imgBg addSubview:labName];
    
    rect = CGRectMake(5, 40, 270, 20);
    UILabel * labQQ = [[[UILabel alloc]initWithFrame:rect]autorelease];
    labQQ.text = @"联系QQ:   479408690";
    labQQ.backgroundColor = [UIColor clearColor];
    [imgBg addSubview:labQQ];
    
    rect = CGRectMake(5, 70, 270, 20);
    UILabel * labPhone = [[[UILabel alloc]initWithFrame:rect]autorelease];
    labPhone.text = @"联系电话:  15921931771";
    labPhone.backgroundColor = [UIColor clearColor];
    [imgBg addSubview:labPhone];
    
    [self.view addSubview:imgBg];
}

-(void)showADVAnmi:(BOOL)bDown
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelay:1.0];
    
    if(bDown)
    {
        _adVgView.frame = CGRectMake(0, 310, 320, 50);
    }
    else
    {
        _adVgView.frame = CGRectMake(0, 0, 320, 50);
    }
 
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(advAnmiStop)];
    
    //[UIView setAnimationRepeatCount:3];
    //[UIView setAnimationRepeatAutoreverses:YES];
    
    [UIView commitAnimations];
}


- (void)advAnmiStop
{
    static BOOL bFlag = NO;
    
    //[self showADVAnmi:bFlag];
    
    bFlag = !bFlag;
}


-(void)dealloc
{
    [_bannerView release];
    [_adVgView release];
    
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











