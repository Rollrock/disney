//
//  ListViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-10.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"
#import "dataStruct.h"
#import "EGORefreshTableHeaderView.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "ShopDetailViewController.h"

#define CELL_HEIGHT  80.0f

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,DPRequestDelegate>
{
    UITableView * _tabView;
    EGORefreshTableHeaderView * _headView;
    NSMutableArray * _dataArray;//存放大众点评数据
    
    DPAPI * _dpApi;
    
    BOOL  _isLoading;
    
    UIView * _dpLogView;
}

@end

@implementation ListViewController

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
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);

    
    _tabView = [[[UITableView alloc]initWithFrame:rect]autorelease];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    [self.view addSubview:_tabView];
    
    
    rect = CGRectMake(0, -65, 320, 65);
    _headView = [[EGORefreshTableHeaderView alloc]initWithFrame:rect];
    _headView.delegate = self;
    [_tabView addSubview:_headView];
    
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    _isLoading = NO;

    
    [self initDPApi];
    
    
    //
    rect = CGRectMake(0, 0, 320, 20);
    _dpLogView = [[[UIView alloc]initWithFrame:rect]autorelease];
    _dpLogView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
    
    rect = CGRectMake(155, 2, 13, 13);
    UIImageView * dpImgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    dpImgView.image = [UIImage imageNamed:@"dplog"];
    [_dpLogView addSubview:dpImgView];
    
    rect = CGRectMake(170, 2, 150, 15);
    UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"以下数据来自大众点评网";
    lab.font = [UIFont systemFontOfSize:12];
    [_dpLogView addSubview:lab];
    
    [self.view addSubview:_dpLogView];
}

-(void)initDPApi
{
    if( _dpApi == nil )
    {
         _dpApi = [[DPAPI alloc]init];
    }
    
    NSString * str = @"v1/business/find_businesses_by_coordinate";
    
    AppDelegate * appDe = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    if( _dataType == DATA_TYPE_EAT )
    {
        
        if( TARGET_IPHONE == 1 )
        {
            NSString * strPar = [NSString stringWithFormat:@"longitude=%f&latitude=%f&platform=2&limit=20&radius=3500&keyword=川菜" ,appDe.longitude,appDe.latitude];
            
            [_dpApi requestWithURL:str paramsString:strPar delegate:self];

        }
        else
        {
            [_dpApi requestWithURL:str paramsString:@"longitude=121.6313&latitude=31.1992&platform=2&limit=20&radius=3500&keyword=川菜" delegate:self];
        }
    }
    else if( _dataType == DATA_TYPE_HOTEL )
    {
        
        if( TARGET_IPHONE == 1 )
        {
            NSString * strPar = [NSString stringWithFormat:@"longitude=%f&latitude=%f&platform=2&limit=20&radius=3500&keyword=宾馆" ,appDe.longitude,appDe.latitude];
            
            [_dpApi requestWithURL:str paramsString:strPar delegate:self];
        }
        else
        {
            [_dpApi requestWithURL:str paramsString:@"longitude=121.6313&latitude=31.1992&platform=2&limit=20&radius=3500&keyword=宾馆" delegate:self];
        }
    }
    else
    {
    }

}


- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
	//self.resultTextView.contentOffset = CGPointZero;
	//self.resultTextView.text = [error description];
    
    [self reloadDataSourceDone];
}


- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSDictionary * dict = result;
    
    if( [dict isKindOfClass:[NSDictionary class]] )
    {
        NSString * strStatus = [dict objectForKey:@"status"];
        
        if( [strStatus isEqualToString:@"OK"])
        {

            [_dataArray removeAllObjects];

            
            NSArray * array = [dict objectForKey:@"businesses"];
            
            if( [array isKindOfClass:[NSArray class]] )
            {
                for( NSDictionary * subDict in array )
                {
                    if( [subDict isKindOfClass:[NSDictionary class]] )
                    {
                        DZDPListInfo * info = [[[DZDPListInfo alloc]init]autorelease];
                        
                        [info fromDict:subDict];
                        
                        [_dataArray addObject:info];
                    }
                }
            }

        }
    }
    
        
    [_tabView reloadData];
    
    [self reloadDataSourceDone];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count:%d",[_dataArray count]);
    return [_dataArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailViewController * vc = [[[ShopDetailViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    vc.busId = ((DZDPListInfo*)[_dataArray objectAtIndex:indexPath.row]).busId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    CGRect rect;
    
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    UITableViewCell * cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == nil )
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    rect = CGRectMake(0, 0, 300,CELL_HEIGHT);
    
    ListViewCell * view = [[[ListViewCell alloc]initWithFrame:rect withData:[_dataArray objectAtIndex:indexPath.row]]autorelease];
    
    
    [cell.contentView addSubview:view];
    
    return cell;
}


-(void)reloadDataSourceDone
{
    _isLoading = NO;
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_tabView];
}

-(void)reloadDataSource
{
    _isLoading = YES;
    
   // [self downLoadTourList];
    
    [self initDPApi];
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
    [_tabView release];
    
    [_dataArray removeAllObjects];
    [_dataArray release];
    
    [_dpApi release];
    
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)loadtestData
{
    
    NSString * str;
    
    if( _dataType == DATA_TYPE_EAT )
    {
        str = @"eat.txt";
    }
    else if( _dataType == DATA_TYPE_HOTEL )
    {
        str = @"hotel.txt";
    }
    else
    {
        str = @"";
    }
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:str];
    NSString * strText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"strText:%@",strText);
    
    NSDictionary * dict = [strText objectFromJSONString];
    
    if( [dict isKindOfClass:[NSDictionary class]] )
    {
        NSString * strStatus = [dict objectForKey:@"status"];
        
        if( [strStatus isEqualToString:@"OK"])
        {
            NSArray * array = [dict objectForKey:@"businesses"];
            
            if( [array isKindOfClass:[NSArray class]] )
            {
                for( NSDictionary * subDict in array )
                {
                    if( [subDict isKindOfClass:[NSDictionary class]] )
                    {
                        DZDPListInfo * info = [[[DZDPListInfo alloc]init]autorelease];
                        
                        [info fromDict:subDict];
                        
                        [_dataArray addObject:info];
                    }
                }
            }
            
        }
    }
    
    
    [_tabView reloadData];
    
}


@end
