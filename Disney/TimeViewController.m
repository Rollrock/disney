//
//  TimeViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-18.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "TimeViewController.h"
#import "dataStruct.h"


#define TIME_WEB_URL_STR  @"http://www.999dh.net/disney/time.html"

@interface TimeViewController ()
{
    UIWebView * _webView;
}
@end

@implementation TimeViewController

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
    
    CGRect rect;
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET-STATUS_BAR_HEIGHT);
    _webView = [[UIWebView alloc]initWithFrame:rect];
    
    NSURL * url = [NSURL URLWithString:TIME_WEB_URL_STR];
    
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    [self.view addSubview:_webView];
    [_webView loadRequest:req];
}


-(void)dealloc
{
    
    [_webView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
