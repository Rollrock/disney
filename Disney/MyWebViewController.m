//
//  MyWebViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-29.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "MyWebViewController.h"
#import "dataStruct.h"

@interface MyWebViewController ()
{
    UIWebView * _webView;
}
@end

@implementation MyWebViewController

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
    
    [self clearCookies];
    
    CGRect rect;
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET-STATUS_BAR_HEIGHT);
    
    _webView  = [[UIWebView alloc]initWithFrame:rect];
    
    NSURL * url = [NSURL URLWithString:self.urlStr];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
    [self.view addSubview:_webView];
}


-(void)clearCookies
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
