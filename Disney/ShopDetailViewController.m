//
//  ShopDetailViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-15.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "dataStruct.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"


#define IMAGE_WIDTH 95
#define IMAGE_HEIGHT 70

@interface ShopDetailViewController ()<DPRequestDelegate>
{
    UIScrollView * _scrView;
    
    DPAPI * _dpApi;
    
    NSInteger _reqType;// 0:基本信息    1:点评
    DZDPShopDetailInfo * _shopInfo;
    //DZDPComment * _comment;
    NSMutableArray * _commentArray;
}
@end

@implementation ShopDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _dpApi = [[DPAPI alloc]init];
        
        _commentArray = [[NSMutableArray alloc]initWithCapacity:0];
        _shopInfo = [[DZDPShopDetailInfo alloc]init];
    }
    return self;
}


-(void)layoutView
{
    CGRect rect;
    CGFloat yPos;
    CGFloat height;
    //NSInteger cmmCount=3;//点评个数
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    _scrView = [[UIScrollView alloc]initWithFrame:rect];
    [self.view addSubview:_scrView];
    
    {
        rect = CGRectMake(0, 0, 320, 110);
        UIView * view = [[[UIView alloc]initWithFrame:rect]autorelease];
        view.backgroundColor = [UIColor whiteColor];
        [_scrView addSubview:view];
        
        rect = CGRectMake(10, 5, 300, 20);
        UILabel * lab1 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab1.text = _shopInfo.shopName; //@"龙门鱼腹(张江店)";
        lab1.backgroundColor = [UIColor clearColor];
        [view addSubview:lab1];
        
        rect = CGRectMake(10, 5+20+5, IMAGE_WIDTH, IMAGE_HEIGHT);
        UIImageView * imgView2 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        //imgView2.image = [UIImage imageNamed:@"1"];
        //[imgView2 setImageWithURL:[NSURL URLWithString:@"http://i3.dpfile.com/pc/0ff70e6d8e3fc91379ea3470966116fb(278x200)/thumb.jpg"]];
        [imgView2 setImageWithURL:[NSURL URLWithString:_shopInfo.shopUrl]];
        
        
        [view addSubview:imgView2];
        
        rect = CGRectMake(10+IMAGE_WIDTH+10, 5+20+5, 82, 16);
        UIImageView * imgView3 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        //[imgView3 setImageWithURL:[NSURL URLWithString:@"http://i1.dpfile.com/s/i/app/api/16_35star.png"]];
        
        [imgView3 setImageWithURL:[NSURL URLWithString:_shopInfo.shopStarUrl]];
        
        [view addSubview:imgView3];
        
        
        rect = CGRectMake(10+IMAGE_WIDTH+10, 5+20+5+16+8 , 200, 20);
        UILabel * lab4 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab4.text = [NSString stringWithFormat:@"人均:%d元",_shopInfo.avgPrice];
        lab4.textColor = [UIColor grayColor];
        lab4.backgroundColor = [UIColor clearColor];
        [view addSubview:lab4];
        
        rect = CGRectMake(10+IMAGE_WIDTH+10, 5+20+5+16+5 +20+12 , 200, 20);
        UILabel * lab5 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab5.text = [NSString stringWithFormat:@"口味:%d 坏境:%d 服务:%d",_shopInfo.taste,_shopInfo.env,_shopInfo.service];
        lab5.backgroundColor = [UIColor clearColor];
        lab5.textColor = [UIColor grayColor];
        [view addSubview:lab5];
        
        rect = CGRectMake(0, 110-2, 320, 2);
        UILabel * lab6 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab6.backgroundColor = [UIColor orangeColor];
        [view addSubview:lab6];
        
        
        yPos = 110;
    }
    
    {
        rect = CGRectMake(0, yPos, 320, 45);
        
        UIView * view = [[[UIView alloc]initWithFrame:rect]autorelease];
        view.backgroundColor = [UIColor whiteColor];
        [_scrView addSubview:view];
        
        rect= CGRectMake(10, 5, 300, 30);
        UILabel * lab =[[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text =_shopInfo.shopAddr;// @"盛夏路110号(近高科中路)";
        [view addSubview:lab];
        
        
        rect = CGRectMake(0, 45-2, 320, 2);
        UILabel * lab2 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab2.backgroundColor = [UIColor orangeColor];
        [view addSubview:lab2];
        
        
        yPos += 45;
    }
    
    {
        rect = CGRectMake(0, yPos, 320, 45);
        
        UIView * view = [[[UIView alloc]initWithFrame:rect]autorelease];
        view.backgroundColor = [UIColor whiteColor];
        [_scrView addSubview:view];
        
        rect= CGRectMake(10, 5, 300, 30);
        UILabel * lab =[[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = _shopInfo.tel;//@"021-10086";
        [view addSubview:lab];
        
        
        rect = CGRectMake(0, 45-2, 320, 2);
        UILabel * lab2 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab2.backgroundColor = [UIColor orangeColor];
        [view addSubview:lab2];
        
        
        yPos += 45;
    }
    
    //
    for( NSInteger index = 0; index < [_commentArray count]; ++ index )
    {
        UIView * view = [[[UIView alloc]initWithFrame:rect]autorelease];
        view.backgroundColor = [UIColor whiteColor];
        
        rect = CGRectMake(5, 5, 300, 20);
        UILabel * lab1 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        //lab1.text = @"装嘲笑";
        lab1.text = ((DZDPComment*)[_commentArray objectAtIndex:index]).name;
        lab1.backgroundColor = [UIColor clearColor];
        [view addSubview:lab1];
        
        
        rect = CGRectMake(5, 20+8, 86, 16);
        UIImageView * imgVeiw2 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        //[imgVeiw2 setImageWithURL:[NSURL URLWithString:@"http://i1.dpfile.com/s/i/app/api/16_35star.png"]];
        [imgVeiw2 setImageWithURL:[NSURL URLWithString: ((DZDPComment*)[_commentArray objectAtIndex:index]).starUrl]];
        [view addSubview:imgVeiw2];
        
        //NSString * strText = @"阿打发斯蒂芬垃圾的发家发垃圾了；啊极大解放辣椒放辣椒的收费了；阿娇的法律；阿姐夫阿大发发啊啊啊bbbbbbb阿迪是发生的法律是打飞机；";
        NSString * strText = ((DZDPComment*)[_commentArray objectAtIndex:index]).comment;
        UILabel * lab3 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab3.backgroundColor = [UIColor clearColor];
        lab3.numberOfLines = 0;
        lab3.lineBreakMode = NSLineBreakByWordWrapping;
        lab3.text = strText;
        lab3.font = [UIFont systemFontOfSize:14];
        height = [self heightForString:strText fontSize:14.0f andWidth:310];
        lab3.frame = CGRectMake(5, 20+8+20, 310, height);
        [view addSubview:lab3];
        
        view.frame = CGRectMake(0, yPos, 320,  20+8+20 + height+3+5);
        [_scrView addSubview:view];
        
        yPos += 20+8+20 + height +3+ 2+5;
        
    }
    
    _scrView.contentSize = CGSizeMake(320, yPos);

    self.view.backgroundColor = [UIColor grayColor];

}

//基本信息
-(void)getShopInfo
{
    NSString * str = @"v1/business/get_single_business";
    NSString * req = [NSString stringWithFormat:@"business_id=%d&format=json&out_offset_type=1&platform=2",_busId];
    
    [_dpApi requestWithURL:str paramsString:req delegate:self];
    
}

//点评
-(void)getComment
{
    NSString * str = @"v1/review/get_recent_reviews";
    NSString * req = [NSString stringWithFormat:@"business_id=%d&format=json",_busId];
    
    [_dpApi requestWithURL:str paramsString:req delegate:self];

}


- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.height;
}



- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{

    NSLog(@"dzdpReauest-error:%d",_reqType);
    
    //[self reloadDataSourceDone];
}


- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if( _reqType == 0 )
    {
        NSArray * array = [result objectForKey:@"businesses"];
        
        for( NSDictionary * dict in array )
        {
            if( [dict isKindOfClass:[NSDictionary class]])
            {
                [_shopInfo fromDict:dict];
            }
        }

        _reqType = 1;
        [self getComment];
        
    }
    else
    {
        NSArray * array = [result objectForKey:@"reviews"];
        
        for( NSDictionary * dict in array )
        {
            if( [dict isKindOfClass:[NSDictionary class]])
            {              
                DZDPComment * comment = [[[DZDPComment alloc]init]autorelease];
                [comment fromDict:dict];
                [_commentArray addObject:comment];
            }
        }
        
        
    [self layoutView];
    
    }
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
    
    _reqType = 0;
    [self getShopInfo];
    
    
    //[self layoutView];
}


-(void)dealloc
{
    [_scrView release];
    
    [_commentArray removeAllObjects];
    [_commentArray release];
    
    [_shopInfo release];
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
