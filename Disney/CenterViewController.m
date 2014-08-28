//
//  CenterViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "CenterViewController.h"
#import "SceneryDetailViewController.h"
#import "dataStruct.h"


#define PIG_WIDTH 697
#define PIG_HEIGHT 622

#define PT_1_X 140
#define PT_1_Y 155

#define PT_2_X 218
#define PT_2_Y 96

#define PT_3_X 100
#define PT_3_Y 250

#define PT_4_X 230
#define PT_4_Y 185

#define PT_5_X 400
#define PT_5_Y 150

#define PT_6_X 500
#define PT_6_Y 250

#define PT_7_X 366
#define PT_7_Y 375


#define PIN_WIDHT 64
#define PIN_HEIGHT 78


/*
 1  迷离庄园   140 155
 2  反斗奇兵大本营  218  96
 3  灰熊山谷   100 250
 4  探险世界    230  185
 5  幻想世界    400 150
 6  明日世界    500  250
 7  美国大街小镇  366 375
 
 */

@interface CenterViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrView;
    NSMutableArray * _btnArray;
    NSMutableArray * _ptArray;
}

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _ptArray = [[NSMutableArray alloc]init];
        _btnArray = [[NSMutableArray alloc]init];
        
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
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    [self.view setFrame:rect];
    
    
    [self layoutView];
    
    
    self.view.backgroundColor = [UIColor blackColor];
}


-(void)layoutView
{
    CGRect rect;

    UIImage * img = [UIImage imageNamed:@"about1"];
    
    UIImageView *iv = [[[UIImageView alloc] initWithImage:img] autorelease];
    iv.userInteractionEnabled = YES;
    iv.tag = 2001;
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    _scrView = [[UIScrollView alloc] initWithFrame:rect];
    _scrView.contentSize = CGSizeMake(img.size.width, img.size.height);
    _scrView.delegate = self; //设定代理对象
    
    float minzoomx = _scrView.frame.size.width / img.size.width;
    float minzoomy = _scrView.frame.size.height / img.size.height;
    
    _scrView.minimumZoomScale = MIN(minzoomx, minzoomy);  //最小缩放到当前ScrollView的大小比例
    _scrView.minimumZoomScale = 0.5f;
    _scrView.maximumZoomScale = 3.0f; //最大缩放到图片的3倍
    _scrView.bounces = NO;
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    
    [_scrView addSubview:iv];
    
    [self.view addSubview:_scrView];
    
    [self addBtn:CGPointMake(PT_1_X - 15, PT_1_Y - 72) withView:iv withTag:1];
    [self addBtn:CGPointMake(PT_2_X - 15, PT_2_Y - 72) withView:iv withTag:2];
    [self addBtn:CGPointMake(PT_3_X - 15, PT_3_Y - 72) withView:iv withTag:3];
    [self addBtn:CGPointMake(PT_4_X - 15, PT_4_Y - 72) withView:iv withTag:4];
    [self addBtn:CGPointMake(PT_5_X - 15, PT_5_Y - 72) withView:iv withTag:5];
    [self addBtn:CGPointMake(PT_6_X - 15, PT_6_Y - 72) withView:iv withTag:6];
    [self addBtn:CGPointMake(PT_7_X - 15, PT_7_Y - 72) withView:iv withTag:7];

}


-(void)addBtn:(CGPoint)point withView:(UIView*)view withTag:(NSInteger)tag
{
    UIImage * img = [UIImage imageNamed:@"pinRed"];
    
    UIImageView * imgView = [[[UIImageView alloc]initWithImage:img]autorelease];
    imgView.frame = CGRectMake(point.x, point.y, PIN_WIDHT,PIN_HEIGHT);
    imgView.tag = [_btnArray count];
    imgView.tag = tag;
    
    [view addSubview:imgView];
    
    [_btnArray addObject:imgView];
    [self addGesture:imgView];
}


-(void)addGesture:(UIImageView*)imgView //withTag:(NSInteger)tag
{
    imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * gesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)]autorelease];
    
    [imgView addGestureRecognizer:gesture];
}


-(void)imgClick:(UITapGestureRecognizer*)g
{
    NSLog(@"~~~g-%d",g.view.tag);
    
    /*
     1  迷离庄园   140 155
     2  反斗奇兵大本营  218  96
     3  灰熊山谷   100 250
     4  探险世界    230  185
     5  幻想世界    400 150
     6  明日世界    500  250
     7  美国大街小镇  366 375
     */
    
    SceneryDetailViewController * vc = [[[SceneryDetailViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    
    if( g.view.tag == 1 )
    {
        vc.sceneryName = @"mlzy";
    }
    else if( g.view.tag == 2 )
    {
        vc.sceneryName = @"fdqbdby";
    }
    else if( g.view.tag == 3 )
    {
        vc.sceneryName = @"hxsg";
    }
    else if( g.view.tag == 4 )
    {
        vc.sceneryName = @"txsj";
    }
    else if( g.view.tag == 5 )
    {
        vc.sceneryName = @"hxsj";
    }
    else if( g.view.tag == 6 )
    {
        vc.sceneryName = @"mrsj";
    }
    else if( g.view.tag == 7 )
    {
        vc.sceneryName = @"mgxzdj";
    }
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self.view viewWithTag:2001];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    for( NSInteger index = 0; index < [_btnArray count]; ++ index )
    {
        CGRect frame = ((UIImageView*)[_btnArray objectAtIndex:index]).frame;
        
        frame.size.width = PIN_WIDHT/scrollView.zoomScale;
        frame.size.height = PIN_HEIGHT/scrollView.zoomScale;
        
        if( index == 0 )
        {
            frame.origin.x = PT_1_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_1_Y - 72/scrollView.zoomScale;
        }
        else if( index == 1 )
        {
            frame.origin.x = PT_2_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_2_Y - 72/scrollView.zoomScale;
        }
        else if( index == 2 )
        {
            frame.origin.x = PT_3_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_3_Y - 72/scrollView.zoomScale;
        }
        else if( index == 3 )
        {
            frame.origin.x = PT_4_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_4_Y - 72/scrollView.zoomScale;
        }
        else if( index == 4 )
        {
            frame.origin.x = PT_5_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_5_Y - 72/scrollView.zoomScale;
        }
        else if( index == 5 )
        {
            frame.origin.x = PT_6_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_6_Y - 72/scrollView.zoomScale;
        }
        else if( index == 6 )
        {
            frame.origin.x = PT_7_X - 15/scrollView.zoomScale;
            frame.origin.y = PT_7_Y - 72/scrollView.zoomScale;
        }
        
        ((UIImageView*)[_btnArray objectAtIndex:index]).frame = frame;
    }
}

-(void)dealloc
{
    [_ptArray removeAllObjects];
    [_ptArray release];
    
    [_btnArray removeAllObjects];
    [_btnArray release];
    
    [_scrView release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
