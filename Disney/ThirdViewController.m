//
//  FirstViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "ThirdViewController.h"
#import "TourCellView.h"
#import "JSONKit.h"
#import "EGORefreshTableHeaderView.h"
//#import "GADBannerView.h"
#import "BaiduMobAdView.h"

#import "MyWaitView.h"

#define CELL_HEIGHT 60.0f


@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,BaiduMobAdViewDelegate>
{
    NSMutableArray * _tourGuideArray;
    EGORefreshTableHeaderView * _headView;
    MyWaitView * _waitView;
    
    BOOL  _isLoading;
}

@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}


-(void)laytouADVView:(CGRect)rect
{
    /*
    GADBannerView *_bannerView;
    //_bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0.0,0,320,50)];//设置位置
    _bannerView = [[[GADBannerView alloc]initWithFrame:rect]autorelease];//设置位置
    
    _bannerView.adUnitID = ADMOB_ID;//调用你的id
    
    _bannerView.rootViewController = self;
    
    [self.view addSubview:_bannerView];//添加bannerview到你的试图
    
    [_bannerView loadRequest:[GADRequest request]];
     */
    
    BaiduMobAdView * _baiduView = [[BaiduMobAdView alloc]init];
    _baiduView.AdType = BaiduMobAdViewTypeBanner;
    _baiduView.frame = CGRectMake(0, rect.origin.y, kBaiduAdViewBanner320x48.width, kBaiduAdViewBanner320x48.height);
    
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
    
    //
    CGRect rect;
    rect = CGRectMake(0, 0, 320, 100);
    [self laytouADVView:rect];
    
    
    rect = CGRectMake(0, 50, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5-50);
    
    [self.view setFrame:rect];
     
    _tabView = [[UITableView alloc]initWithFrame:rect];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    [self.view addSubview:_tabView];
    
    /*
    rect = CGRectMake(0, -65, 320, 65);
    _headView = [[EGORefreshTableHeaderView alloc]initWithFrame:rect];
    _headView.delegate = self;
    [_tabView addSubview:_headView];
    */
    
    _tourGuideArray = [[NSMutableArray alloc]initWithCapacity:1];

    _isLoading = NO;
    
    
    [self parseData];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row:%d",indexPath.row);
    
    TourDetailViewController * vc = [[TourDetailViewController alloc]initWithNibName:nil bundle:nil];
    vc.infoUrl = ((TourGuideInfo*)[_tourGuideArray objectAtIndex:indexPath.row]).detailUrl;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count:%d",[_tourGuideArray count]);
    return [_tourGuideArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    
    UITableViewCell * cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if( !cell )
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     TourCellView * view = [[[TourCellView alloc]initWithFrame:CGRectMake(0, 0, 300, CELL_HEIGHT) withInfo:[_tourGuideArray objectAtIndex:indexPath.row]]autorelease];

    [cell.contentView addSubview:view];
        
    return cell;
}


-(void)parseData
{
    [_tourGuideArray removeAllObjects];
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tourlist.txt"];
    
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict = [data objectFromJSONData];
    
    NSArray * array  = [dict objectForKey:@"info"];
    
    for(NSDictionary * subDict in array )
    {
        if( [subDict isKindOfClass:[NSDictionary class]])
        {
            TourGuideInfo * info = [[[TourGuideInfo alloc]init]autorelease];
            [info fromDict:subDict];
            [_tourGuideArray addObject:info];
        }
    }
    
    [_tabView reloadData];
}


-(void)reloadDataSourceDone
{
    _isLoading = NO;
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_tabView];
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
    [self reloadDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _isLoading;
}


-(void)dealloc
{
    [_conn release];
    [_data release];
    [_tabView release];
    
    [_tourGuideArray removeAllObjects];
    [_tourGuideArray release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


























