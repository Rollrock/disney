//
//  TourDetailViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-25.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "TourDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "dataStruct.h"
#import "GADBannerView.h"

#define TOUR_DETAIL_IMAGE_WIDTH 310.0f
#define TOUR_DETAIL_IMAGE_HEIGHT 200.0f

#define TOUR_DETAIL_INFO_FILE_NAME @"tour_detail_file.txt"

@interface TourDetailViewController ()
{
    NSMutableArray * imgDataArray;
    NSMutableString * descText;
    NSMutableString * trafText;
    
    NSMutableArray * imgViewArray;
    UIScrollView * scrView;
    UILabel * textLabel;
    UILabel * trafLabel;
    
    NSURLConnection * coon;
    NSMutableData * data;
    
    GADBannerView *_bannerView;
    
}
@end

@implementation TourDetailViewController

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
    
    imgViewArray = [[NSMutableArray alloc]initWithCapacity:1];
    imgDataArray = [[NSMutableArray alloc]initWithCapacity:1];
    descText = [[NSMutableString alloc]initWithCapacity:1];
    trafText = [[NSMutableString alloc]initWithCapacity:1];
    
    [self parseData];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)initADVView:(CGRect)rect withView:(UIView*)view
{
    _bannerView = [[GADBannerView alloc]initWithFrame: rect];//CGRectMake(0.0,0,320,50)];//设置位置
    
    _bannerView.adUnitID = ADMOB_ID;//调用你的id
    
    _bannerView.rootViewController = self;
    
    [view addSubview:_bannerView];//添加bannerview到你的试图
    
    [_bannerView loadRequest:[GADRequest request]];
}


-(void)laytouView
{
    /*
    NSInteger index = 0;
    CGFloat yPos = 0.0;
    
    CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);

    scrView = [[UIScrollView alloc]initWithFrame:rect];
    
    [self.view addSubview:scrView];
    
    for( index = 0; index < [imgDataArray count]; ++ index)
    {
        CGRect rect = CGRectMake(5, index*(TOUR_DETAIL_IMAGE_HEIGHT+3)+5, TOUR_DETAIL_IMAGE_WIDTH, TOUR_DETAIL_IMAGE_HEIGHT);
        
        UIImageView * imageView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        NSString * strUrl = [imgDataArray objectAtIndex:index];
        NSURL * url = [NSURL URLWithString:strUrl];
        [imageView setImageWithURL:url];
        
        [scrView addSubview:imageView];
    }
    
    textLabel = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.backgroundColor = [UIColor redColor];
    
    textLabel.text = strText;
    yPos = [self heightForString:strText fontSize:14 andWidth:TOUR_DETAIL_IMAGE_WIDTH];
    textLabel.frame = CGRectMake(5, index*(TOUR_DETAIL_IMAGE_HEIGHT+3)+15, TOUR_DETAIL_IMAGE_WIDTH, yPos);

    [scrView addSubview:textLabel];
    
    scrView.contentSize = CGSizeMake(320, index*(TOUR_DETAIL_IMAGE_HEIGHT+3) +25 + yPos);
     */
    
    
    NSInteger index = 0;
    CGFloat yPos = 0.0;
    
    CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    scrView = [[UIScrollView alloc]initWithFrame:rect];
    
    [self.view addSubview:scrView];
    
    for( index = 0; index < [imgDataArray count]; ++ index)
    {
        CGRect rect = CGRectMake(5, index*(TOUR_DETAIL_IMAGE_HEIGHT+3)+5, TOUR_DETAIL_IMAGE_WIDTH, TOUR_DETAIL_IMAGE_HEIGHT);
        
        UIImageView * imageView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        
        NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[imgDataArray objectAtIndex:index]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        imageView.image = image;

        
        [scrView addSubview:imageView];
    }
    
    //广告
    rect = CGRectMake(5, index*(TOUR_DETAIL_IMAGE_HEIGHT+5), TOUR_DETAIL_IMAGE_WIDTH, 100);
    [self initADVView:rect withView:scrView];
    
    //简要介绍
    textLabel = [[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:14];
    //textLabel.backgroundColor = [UIColor redColor];
    
    textLabel.text = descText;
    yPos = [self heightForString:descText fontSize:14 andWidth:TOUR_DETAIL_IMAGE_WIDTH];
    textLabel.frame = CGRectMake(5, index*(TOUR_DETAIL_IMAGE_HEIGHT+3)+15 +100, TOUR_DETAIL_IMAGE_WIDTH, yPos);
    
    [scrView addSubview:textLabel];
    
    yPos += index*(TOUR_DETAIL_IMAGE_HEIGHT+3)+15 +100;
    //公交信息
    rect = CGRectMake(5, yPos, TOUR_DETAIL_IMAGE_WIDTH, 0);
    trafLabel = [[[UILabel alloc]initWithFrame:rect]autorelease];
    trafLabel.font = [UIFont systemFontOfSize:14];
    trafLabel.numberOfLines = 0;
    trafLabel.text = trafText;
    yPos = [self heightForString:trafText fontSize:14 andWidth:TOUR_DETAIL_IMAGE_WIDTH];
    rect = trafLabel.frame;
    rect.size.height = yPos;
    trafLabel.frame = rect;
    yPos = rect.size.height + rect.origin.y;
    
    [scrView addSubview:trafLabel];
    
    
    //
    scrView.contentSize = CGSizeMake(320, yPos+20);
    
}




-(void)parseData
{
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:_infoUrl];
    
    NSData * da = [NSData dataWithContentsOfFile:filePath];
    
    NSString * str = [[[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding]autorelease];
    
    da = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict = [da objectFromJSONData];
    
    NSArray * array  = [dict objectForKey:@"img"];
    
    for(NSDictionary * subDict in array )
    {
        if( [subDict isKindOfClass:[NSDictionary class]])
        {
            NSString * str = [subDict objectForKey:@"imgUrl"];
            [imgDataArray addObject:str];
        }
    }
    
    NSLog(@"--%@--",[dict objectForKey:@"desc"]);
    
    [descText appendString:[dict objectForKey:@"desc"]];
    [trafText appendString:[dict objectForKey:@"traf"]];
    
    [self laytouView];

}


- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.height;
}


-(void)dealloc
{
    [_bannerView release];
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
