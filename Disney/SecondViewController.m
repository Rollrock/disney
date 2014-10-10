//
//  SecondViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "SecondViewController.h"
#import "WayViewController.h"
#import "WayWeatherViewController.h"
#import "ListViewController.h"
#import "dataStruct.h"
#import "MyWebViewController.h"

#import "ShopDetailViewController.h"
#import "TimeViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

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
    
    //CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    //[self.view setFrame:rect];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self layoutView];
}

-(UIColor*)colorWithR:(CGFloat)r withG:(CGFloat)g withB:(CGFloat)b
{
    UIColor *color= [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    return color;
}


-(void)addBtnEvent:(UIButton*)btn
{
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
}

-(void)layoutView
{
    #define CELL_VIEW_WIDTH 158
    #define CELL_X_TIP 4
    #define CELL_Y_TIP 4
    
    CGRect rect;
   // NSLog(@"!!!!-%f=%f--%f",self.view.frame.origin.y,self.view.frame.size.height,[[UIScreen mainScreen] bounds].size.height);
    
    UIScrollView * scrView = [[[UIScrollView alloc]initWithFrame:CGRectZero]autorelease];
     scrView.frame =CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    [self.view addSubview:scrView];
    
    {
        rect = CGRectMake(0, 0, CELL_VIEW_WIDTH, 120);
        UIButton * btn1 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn1.tag = 1;
        btn1.backgroundColor = [UIColor greenColor];
        [self addBtnEvent:btn1];
        [scrView addSubview:btn1];
        
        rect = CGRectMake(15, 15, 120, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"时间表";
        [btn1 addSubview:lab];
        
        rect = CGRectMake(50, 40, 75, 75);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_time"];
        [btn1 addSubview:imgView];
    }
    
    {
        rect = CGRectMake(0, 120+CELL_X_TIP, CELL_VIEW_WIDTH, 80);
        UIButton * btn2 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn2.tag = 2;
        btn2.backgroundColor = [UIColor whiteColor];
        [self addBtnEvent:btn2];
        [scrView addSubview:btn2];
        
        
        rect = CGRectMake(5, 5, 25, 60);
        UITextView * lab = [[[UITextView alloc]initWithFrame:rect]autorelease];
        lab.editable = NO;
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"交\n通";
        [btn2 addSubview:lab];
        
        rect = CGRectMake(60, 12, 55, 55);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_traffic"];
        [btn2 addSubview:imgView];
    }
    
    {
        rect = CGRectMake(0, 120+80+CELL_X_TIP*2, CELL_VIEW_WIDTH, 100);
        UIButton * btn3 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn3.backgroundColor = [UIColor blueColor];
        [self addBtnEvent:btn3];
        [scrView addSubview:btn3];
        
        
        rect = CGRectMake(110, 15, 30, 60);
        UITextView * lab = [[[UITextView alloc]initWithFrame:rect]autorelease];
        lab.editable = NO;
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"酒\n店";
        lab.scrollEnabled = NO;
        lab.userInteractionEnabled = NO;
        btn3.tag = 3;
        [btn3 addSubview:lab];
        
        rect = CGRectMake(20, 25, 70, 70);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_hotel"];
        [btn3 addSubview:imgView];

    }
    
    {
        /*
        rect = CGRectMake(0, 120+80+100+CELL_X_TIP*3, CELL_VIEW_WIDTH, 130);
        UIButton * btn4 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn4.backgroundColor = [UIColor yellowColor];
        [self addBtnEvent:btn4];
        [scrView addSubview:btn4];
         */
        
        rect = CGRectMake(0, 120+80+100+CELL_X_TIP*3, CELL_VIEW_WIDTH, 130);
        UIButton * btn4 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn4.backgroundColor = [UIColor yellowColor];
        btn4.tag = 4;
        [self addBtnEvent:btn4];
        [scrView addSubview:btn4];
        
        
        rect = CGRectMake(30, 50, 80, 15);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"广告招商";
        lab.backgroundColor = [UIColor clearColor];
        [btn4 addSubview:lab];
        
        
    }
    
    
    /////////////////////////////////////////////////////////////////////////////
    {
        
        rect = CGRectMake(CELL_VIEW_WIDTH+CELL_Y_TIP, 0, CELL_VIEW_WIDTH, 100);
        UIButton * btn5 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn5.backgroundColor = [UIColor whiteColor];
        [self addBtnEvent:btn5];
        btn5.tag= 5;
        [scrView addSubview:btn5];
        
        rect = CGRectMake(8, 8, 120, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"门票价格";
        [btn5 addSubview:lab];
        
        rect = CGRectMake(50, 40, 55, 55);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_ticket"];
        [btn5 addSubview:imgView];
        
    }
    
    {
        rect = CGRectMake(CELL_VIEW_WIDTH+CELL_Y_TIP,100 + CELL_X_TIP, CELL_VIEW_WIDTH, 130);
        UIButton * btn6 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn6.backgroundColor = [UIColor orangeColor];
        btn6.tag = 6;
        [self addBtnEvent:btn6];
        [scrView addSubview:btn6];
        
        rect = CGRectMake(5, 5, 20, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"吃";
        lab.backgroundColor = [UIColor clearColor];
        [btn6 addSubview:lab];
        
        rect = CGRectMake(35, 20, 80, 80);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_eat"];
        [btn6 addSubview:imgView];
        
        rect = CGRectMake(120, 100, 20, 20);
        UILabel * lab2 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab2.text = @"饭";
        lab2.backgroundColor = [UIColor clearColor];
        [btn6 addSubview:lab2];

    }
    
    {
        rect = CGRectMake(CELL_VIEW_WIDTH+CELL_Y_TIP,130 + 100+CELL_X_TIP*2, CELL_VIEW_WIDTH, 120);
        UIButton * btn7 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn7.backgroundColor = [UIColor lightGrayColor];
        btn7.tag = 7;
        [self addBtnEvent:btn7];
        [scrView addSubview:btn7];
        
        rect = CGRectMake(120, 5, 20, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"购";
        lab.backgroundColor = [UIColor clearColor];
        [btn7 addSubview:lab];
        
        rect = CGRectMake(35, 20, 80, 80);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_shopping"];
        [btn7 addSubview:imgView];
        
        rect = CGRectMake(5, 100, 20, 20);
        UILabel * lab2 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab2.text = @"物";
        lab2.backgroundColor = [UIColor clearColor];
        [btn7 addSubview:lab2];
    }
    
    {
        rect = CGRectMake(CELL_VIEW_WIDTH+CELL_Y_TIP,130+100+120+CELL_X_TIP*3, CELL_VIEW_WIDTH, 80);
        UIButton * btn8 = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn8.tag = 8;
        btn8.backgroundColor = [UIColor purpleColor];
        [self addBtnEvent:btn8];
        [scrView addSubview:btn8];
        
        rect = CGRectMake(15, 10, 60, 60);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"way_weather"];
        [btn8 addSubview:imgView];
        
        
        rect = CGRectMake(90, 40, 40, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"天气";
        lab.backgroundColor = [UIColor clearColor];
        [btn8 addSubview:lab];
    }
    
    
    /////////////////////////////////////////////////////////////////////////////
    scrView.contentSize = CGSizeMake(320, 120+80+100+130+CELL_X_TIP*4);
}

-(void)touchDown:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    CGRect rect = btn.frame;
    CGPoint pt = btn.center;
    rect.size.width -= 3;
    rect.size.height -= 3;
    btn.frame = rect;
    btn.center = pt;
    
    for(UIView * view in [btn subviews])
    {
       // if( [view isKindOfClass:[UIImageView class]])
        {
            rect = view.frame;
            
            pt = view.center;
            rect.size.width -= 2;
            rect.size.height -= 2;
            view.frame = rect;
            view.center = pt;
            
          //  break;
        }
    }
}

-(void)touchUp:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    CGRect rect = btn.frame;
    CGPoint pt = btn.center;
    rect.size.width += 3;
    rect.size.height += 3;
    btn.frame = rect;
    btn.center = pt;
    
    
    for(UIView * view in [btn subviews])
    {
       // if( [view isKindOfClass:[UIImageView class]])
        {
            rect = view.frame;
            
            pt = view.center;
            rect.size.width += 2;
            rect.size.height += 2;
            view.frame = rect;
            view.center = pt;
            
           // break;
        }
    }

    
    NSInteger index = btn.tag;
    
    if( 1 == index )
    {      
         MyWebViewController * vc = [[[MyWebViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.urlStr = @"http://www.999dh.net/disney/strategy/time.html";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( 2 == index )
    {
        MyWebViewController * vc = [[[MyWebViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.urlStr = @"http://www.999dh.net/disney/strategy/traffic.html";
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if( 3 == index )
    {
        ListViewController * vc = [[[ListViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.title = @"酒店";
        vc.dataType = DATA_TYPE_HOTEL;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if( 4 == index )
    {
        MyWebViewController * vc = [[[MyWebViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.urlStr = @"http://www.999dh.net/disney/strategy/zhaoshang.html";
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if( 5 == index )
    {
        MyWebViewController * vc = [[[MyWebViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.urlStr = @"http://www.999dh.net/disney/strategy/ticket.html";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if( 6 == index )
    {
        ListViewController * vc = [[[ListViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.title = @"美食";
        vc.dataType = DATA_TYPE_EAT;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if( 7 == index )
    {
        MyWebViewController * vc = [[[MyWebViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.urlStr = @"http://www.999dh.net/disney/strategy/shopping.html";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (8 == index )
    {
        WayWeatherViewController * vc = [[[WayWeatherViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        vc.title = @"天气";
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
