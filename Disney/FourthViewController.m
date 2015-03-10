//
//  FourthViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-25.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "FourthViewController.h"
#import "dataStruct.h"
#import "AboutUsViewController.h"
#import "JSONKit.h"
#import "dataStruct.h"
#import "MyWebViewController.h"
#import "AppDelegate.h"
//#import "youmiconfuse.h"

#define ADV_LIST_URL @"http://www.999dh.net/disney/about/advlist.txt";

@interface FourthViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    
    
    NSMutableData * _data;
    NSURLConnection * _conn;
    NSMutableArray * _array;
}
@end

@implementation FourthViewController

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
    

    CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
     
    [self.view addSubview:_tableView];
    
    
    if( DEVICE_VER_OVER_7 == YES )
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self downLoadInfoFile];
}

-(void)viewDidAppear:(BOOL)animated
{
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
       
    }
}


-(void)downLoadInfoFile
{
    NSString * strUrl = ADV_LIST_URL;
    NSURL * url = [NSURL URLWithString:strUrl];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    NSMutableData * da = [[NSMutableData alloc]init];
    NSURLConnection * con = [[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];
    
    _data = da;
    _conn = con;
    
    if( _conn != nil )
    {
        NSLog(@"create connection success");
    }
    else
    {
        NSLog(@"create connection failed");
    }
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error happended");
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    _array = [[NSMutableArray alloc]initWithCapacity:1];
    
    NSString * str = [[[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding]autorelease];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict = [data objectFromJSONData];
    
    if( [dict isKindOfClass:[NSDictionary class]] )
    {
        NSArray * arr = [dict objectForKey:@"list"];
        
        for( NSDictionary * subDict in arr )
        {
            AboutAdvInfo * info = [[[AboutAdvInfo alloc]init]autorelease];
            [info fromDict:subDict];
            
            [_array addObject:info];
        }
    }
    
    [_tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%d row:%d",indexPath.section, indexPath.row);
    
    switch(indexPath.section)
    {
        case 0:
            if( indexPath.row == 0 )
            {
                AboutUsViewController * vc = [[[AboutUsViewController alloc]initWithNibName:nil bundle:nil]autorelease];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else if( indexPath.row == 1 )
            {
                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"804556227"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
               
            }
            else if( indexPath.row == 2 )
            {
                AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                
                [appDel shareWithTextUrl];
            }
            break;
            
        case 1:
        {
            MyWebViewController * vc = [[[MyWebViewController alloc]init]autorelease];
            vc.urlStr =((AboutAdvInfo*) [_array objectAtIndex:indexPath.row]).url;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            AppDelegate * del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if( [del isWeChatValid ]  )
            {
                return 3;
            }
            else
            {
                return 2;
            }
        }
            break;
            
        case 1:
            return [_array count];
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    
    UITableViewCell * cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if( cell == nil )
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId]autorelease];
    }
    
    switch(indexPath.section)
    {
        case 0:
            if( indexPath.row == 0 )
            {
                [[cell textLabel]setText:@"关于我们"];
            }
            else if( indexPath.row == 1 )
            {
                [[cell textLabel]setText:@"给我打分"];
            }
            else if( indexPath.row == 2 )
            {
                [[cell textLabel] setText:@"微信分享得奖"];
            }
            
            break;
            
        case 1:
        {
            /*
            if( indexPath.row == 0 )
            {
                [[cell textLabel]setText:@"测试标题1"];
            }
            else if( indexPath.row == 1 )
            {
                [[cell textLabel]setText:@"测试标题2"];
            }
             */
            
            AboutAdvInfo * info =(AboutAdvInfo*)[_array objectAtIndex:indexPath.row];
            
            [[cell textLabel] setText:info.title];

        }
             break;
    }

    return cell;
}


-(void)dealloc
{
    [_tableView release];
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
