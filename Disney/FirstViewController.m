//
//  FirstViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "FirstViewController.h"
#import "TourCellView.h"
#import "JSONKit.h"
#import "EGORefreshTableHeaderView.h"
#import "SDWebImageManager.h"
#import "dataStruct.h"
#import "MyAdmobView.h"
#import "BaiduMobAdView.h"

#define INTRO_FILE_NAME @"introlist.txt"
#define BIG_IMAGE_TAG  1001

//#define TOUR_LIST_URL @"http://www.999dh.net/disney/intro/info.txt"

@interface FirstViewController ()<EGORefreshTableHeaderDelegate,BaiduMobAdViewDelegate>
{
    UIImageView * _bigImgView;
    IntroInfo * _intro;
    EGORefreshTableHeaderView * _headView;
    
    CGFloat _yPos;
    BOOL  _isLoading;
    
}

@end

@implementation FirstViewController

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
    else
    {
        //self.view.frame =CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    }
#endif
    
    NSLog(@"!!!!-%f=%f--%f",self.view.frame.origin.y,self.view.frame.size.height,[[UIScreen mainScreen] bounds].size.height);
       
    CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    _scrView = [[UIScrollView alloc]initWithFrame:rect];
    
    [self.view addSubview:_scrView];
    
    rect = CGRectMake(0, -65, 320, 65);
    _headView = [[EGORefreshTableHeaderView alloc]initWithFrame:rect];
    _headView.delegate = self;
    [_scrView addSubview:_headView];
    
    
    _intro = [[IntroInfo alloc]init];
    
    _isLoading = NO;
    
    //[self autoDownLoadTourList];
    
    [self parseData];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self showYOUMIAdv];
}

-(void)showYOUMIAdv
{
    NSDateComponents * data = [[NSDateComponents alloc]init];
    NSCalendar * cal = [NSCalendar currentCalendar];
    
    [data setCalendar:cal];
    [data setYear:SHOW_ADV_YEAR];
    [data setMonth:SHOW_ADV_MONTH];
    [data setDay:SHOW_ADV_DAY];
    
    NSDate * farDate = [cal dateFromComponents:data];

    NSDate *now = [NSDate date];
    
    NSTimeInterval farSec = [farDate timeIntervalSince1970];
    NSTimeInterval nowSec = [now timeIntervalSince1970];
    
    
    if( nowSec - farSec >= 0 )
    {
        if((int)nowSec % 2 == 0 )
        {
        }
        else
        {
            [[MyAdmobView alloc]initWithViewController:self];
        }
    }
}



-(void)showBigImg:(BOOL)bShow withUrlStr:(NSString*)strUrl
{
    if( _bigImgView == nil )
    {
        _bigImgView = [[UIImageView alloc]initWithFrame:CGRectMake(320/2.0, 320*(200/300.0)/2.0, 0, 0)];
        _bigImgView.userInteractionEnabled = YES;
        _bigImgView.tag = BIG_IMAGE_TAG;
        
        UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)]autorelease];
        [_bigImgView addGestureRecognizer:g];
        
        
        [_scrView addSubview:_bigImgView];
    }
    
    if( bShow )
    {
        _bigImgView.image = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:strUrl]];
        
        _bigImgView.hidden = NO;
        
        [UIView beginAnimations:@"showImg" context:nil];
        [UIView setAnimationDuration:0.8f];
        
        _bigImgView.frame = CGRectMake(0, 0, 320, 320*(200/300.0));
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"showImg" context:nil];
        [UIView setAnimationDuration:0.8f];
        
        _bigImgView.frame = CGRectMake(320/2.0, 320*(200/300.0)/2.0, 0, 0);
        
        [UIView commitAnimations];
        
        _bigImgView.hidden = NO;
    }
}


-(void)layoutSepImgView:(UIView*)parView wihtRect:(CGRect)rect
{
    UIImageView * imgSepView;
    
    imgSepView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    imgSepView.image = [UIImage imageNamed:@"sepLine"];
    [parView addSubview:imgSepView];
}



- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.height;
}


-(void)laytouADVView:(CGRect)rect
{
    
    //GAD_SIZE_300x250
    
    /*
     GADBannerView *_bannerView;
     _bannerView = [[[GADBannerView alloc]initWithFrame:rect]autorelease];//设置位置
    
    _bannerView.adUnitID = ADMOB_ID;//调用你的id
    
    _bannerView.rootViewController = self;
    
    [_scrView addSubview:_bannerView];//添加bannerview到你的试图
    
    [_bannerView loadRequest:[GADRequest request]];
     */
    
    
    BaiduMobAdView * _baiduView = [[BaiduMobAdView alloc]init];
    _baiduView.AdType = BaiduMobAdViewTypeBanner;
    _baiduView.frame = CGRectMake(0, rect.origin.y+5, kBaiduAdViewBanner320x48.width, kBaiduAdViewBanner320x48.height);
    
    _baiduView.delegate = self;
    [self.view addSubview:_baiduView];
    [_baiduView start];
}

- (NSString *)publisherId
{
    return @"bf498248";
}

/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString*) appSpec
{
    return @"bf498248";
}


-(void)layoutTextView
{
    
    CGFloat yBegin = _yPos;
    CGFloat strHeight;
    CGRect rect;
    
    //广告
    rect = CGRectMake(5, yBegin, 310, 50);
    
    [self laytouADVView:rect];
    
    
    yBegin += 50+10;
    
    rect = CGRectMake(10, yBegin , 300, 2);
    [self layoutSepImgView:_scrView wihtRect:rect];
    
    
    yBegin += 5;
    rect = CGRectMake(10, yBegin , 300, 30);
    UILabel * lab1 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab1.text = @"上海迪斯尼简介绍:";
    [_scrView addSubview:lab1];
    
    
    yBegin = yBegin+5+30;
    UILabel * lab2 = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
    lab2.text = [_intro.descArray objectAtIndex:0];
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.font = [UIFont systemFontOfSize:13.0];
    lab2.numberOfLines = 0;
    lab2.lineBreakMode = NSLineBreakByCharWrapping;
    strHeight = [self heightForString:[_intro.descArray objectAtIndex:0] fontSize:13.0 andWidth:300];
    lab2.frame = CGRectMake(10, yBegin, 300, strHeight);
    [_scrView addSubview:lab2];
    
    /*------------------------------------------------------*/
    
    yBegin += strHeight + 10;
    rect = CGRectMake(10, yBegin , 300, 2);
    [self layoutSepImgView:_scrView wihtRect:rect];
    
    
    yBegin += 5;
    rect = CGRectMake(10, yBegin, 300, 25);
    UILabel * lab3 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab3.text = @"开放时间";
    [_scrView addSubview:lab3];
    
    yBegin+= 25;
    UITextView * textView4 = [[[UITextView alloc]initWithFrame:CGRectMake(10, yBegin, 300, 50)]autorelease];
    textView4.editable = NO;
    textView4.text = [_intro.descArray objectAtIndex:1];
    textView4.font = [UIFont systemFontOfSize:14];
    [self setTextViewFrame:textView4];
    [_scrView addSubview:textView4];
    yBegin += textView4.frame.size.height;
    
    
   // NSLog(@"textView4:%f-%f",textView4.frame.size.width,textView4.frame.size.height);
    
    /*------------------------------------------------------*/
    
    rect = CGRectMake(10, yBegin , 300, 2);
    [self layoutSepImgView:_scrView wihtRect:rect];
    
    yBegin += 5;
    rect = CGRectMake(10, yBegin, 300, 25);
    UILabel * lab5 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab5.text = @"门票价格";
    [_scrView addSubview:lab5];
    
    yBegin += 25;
    UITextView * textView6 = [[[UITextView alloc]initWithFrame:CGRectMake(10, yBegin, 300, 50)]autorelease];
    textView6.text = [_intro.descArray objectAtIndex:2];
    textView6.font = [UIFont systemFontOfSize:14];
    textView6.editable = NO;
    [self setTextViewFrame:textView6];
    [_scrView addSubview:textView6];
    
    yBegin += textView6.frame.size.height;
    
    /*------------------------------------------------------*/
    
    rect = CGRectMake(10, yBegin , 300, 2);
    [self layoutSepImgView:_scrView wihtRect:rect];
    
    yBegin += 5;
    rect = CGRectMake(10, yBegin, 300, 25);
    UILabel * lab7 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab7.text = @"主题景点";
    [_scrView addSubview:lab7];
    
    yBegin += 25;
    UITextView * textView8 = [[[UITextView alloc]initWithFrame:CGRectMake(10, yBegin, 300, 10)]autorelease];
    textView8.text = [_intro.descArray objectAtIndex:3];
    textView8.font = [UIFont systemFontOfSize:14];
    textView8.editable = NO;
    [self setTextViewFrame:textView8];
    [_scrView addSubview:textView8];
    
    yBegin += textView8.frame.size.height;
    
    /*------------------------------------------------------*/
    
    rect = CGRectMake(10, yBegin , 300, 2);
    [self layoutSepImgView:_scrView wihtRect:rect];
    
    yBegin += 5;
    rect = CGRectMake(10, yBegin, 300, 25);
    UILabel * lab9 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab9.text = @"交通路线";
    [_scrView addSubview:lab9];
    
    yBegin += 25;
    UITextView * textViewA = [[[UITextView alloc]initWithFrame:CGRectMake(10, yBegin, 300, 50)]autorelease];
    textViewA.editable = NO;
    textViewA.text = [_intro.descArray objectAtIndex:4];
    textViewA.font = [UIFont systemFontOfSize:14];
    
    [self setTextViewFrame:textViewA];
    
    [_scrView addSubview:textViewA];
    
    yBegin += textViewA.frame.size.height;
    /*------------------------------------------------------*/
    
    
    /*------------------------------------------------------*/
    yBegin += 20;
    _scrView.contentSize =CGSizeMake(320, yBegin);
    
}


- (void)setTextViewFrame:(UITextView *)textView
{
    /*  before  ios7
      */
    
    // ios7
    
    if( DEVICE_VER_OVER_7 == YES )
    {
        CGRect txtFrame = textView.frame;
        CGFloat textViewContentHeight = txtFrame.size.height =[[NSString stringWithFormat:@"%@\n  ",textView.text]
                                                               boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height;
        
        txtFrame.size.height = textViewContentHeight;
        
        textView.frame = txtFrame;


    }
    else
    {
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        textView.frame = newFrame;

    }
    
    
  }



-(void)layoutImageView
{
    #define IMG_LEFT_TIP 5
    #define IMG_TOP_TIP 5
    #define IMG_RIGHT_TIP 5
    #define IMG_WIDHT 100
    #define IMG_HEIGHT 66
    #define ONE_LINE_IMG_COUNT 3
    
    NSInteger index = 0;
    
    for( index = 0; index < [_intro.imgUrlArray count]; ++ index )
    {
        CGRect rect;
        rect = CGRectMake(IMG_LEFT_TIP + index%ONE_LINE_IMG_COUNT*(IMG_WIDHT+IMG_RIGHT_TIP), IMG_TOP_TIP + index/ONE_LINE_IMG_COUNT*(IMG_HEIGHT+IMG_TOP_TIP), IMG_WIDHT, IMG_HEIGHT);
        
        UIImageView * imageView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        
        NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[_intro.imgUrlArray objectAtIndex:index]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        imageView.image = image;
        
        ////
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)]autorelease];
        [imageView addGestureRecognizer:g];
        imageView.tag = index;
        /////
        
        [_scrView addSubview:imageView];
        
        _yPos = rect.origin.y + rect.size.height;
        
    }
}


-(void)clickImage:(UITapGestureRecognizer*)g
{
    if( g.view.tag == BIG_IMAGE_TAG )
    {
        [self showBigImg:NO withUrlStr:nil];
    }
    else
    {
        [self showBigImg:YES withUrlStr:[ _intro.imgUrlArray objectAtIndex:g.view.tag]];
    }
}

-(void)parseData
{
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Introinfo.txt"];

    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict = [data objectFromJSONData];
    
    [_intro fromDict:dict];
    
    
    [self layoutImageView];
    
    [self layoutTextView];

}



-(void)reloadDataSourceDone
{
    _isLoading = NO;
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrView];
}

-(void)reloadDataSource
{
    _isLoading = YES;
    
 }

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"didTrigger");
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
   // NSLog(@"isLoading:%d",_isLoading);
    return _isLoading;
}


-(void)dealloc
{
    [_conn release];
    [_data release];
    [_scrView release];
    [_headView release];
    
    [_intro release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


























