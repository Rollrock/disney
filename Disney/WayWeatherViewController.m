//
//  WayWeatherViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-5.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

//天气 

#import "WayWeatherViewController.h"
#import "dataStruct.h"
#import "JSONKit.h"

#define WEATHER_URL_STR  @"http://m.weather.com.cn/data/101020100.html"

@interface WayWeatherViewController ()
{
    NSInteger maxTmp;
    NSInteger minTmp;
    
    NSInteger maxTempArr[6];
    NSInteger mixTempArr[6];
    
    NSMutableDictionary * _picDict;
    
    WeatherInfo * _wInfo;
    UIScrollView * _scrView;
}
@end

@implementation WayWeatherViewController

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
    
    [self.view setFrame:rect];
    
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    _picDict = [[NSMutableDictionary alloc]initWithCapacity:1];
    _wInfo = [[WeatherInfo alloc]init];
 
    [self initWindPic];
    
    
    [self getWeatherData];
}


-(void)layoutSepImgView:(UIView*)parView wihtRect:(CGRect)rect
{
    UIImageView * imgSepView;
    
    imgSepView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    imgSepView.image = [UIImage imageNamed:@"sepLine"];
    [parView addSubview:imgSepView];
}


-(void)layoutView
{
    CGRect rect;
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET-STATUS_BAR_HEIGHT);
    
    _scrView = [[UIScrollView alloc]initWithFrame:rect];
    _scrView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"way_weather_bg"]];
        
    [self.view addSubview:_scrView];
    
    
    if( [_wInfo.tmpArray count] <= 0 )
    {
        return;
    }
    
    {
        rect = CGRectMake(15, 10, 180, 40);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [_wInfo.tmpArray objectAtIndex:0];
        lab.font = [UIFont systemFontOfSize:32];
        lab.textColor = [UIColor redColor];
        lab.backgroundColor = [UIColor clearColor];
        [_scrView addSubview:lab];
        
        
        rect = CGRectMake(180+20, 11, 160, 40);
        UILabel * lab2 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab2.text = [_wInfo.wethArray objectAtIndex:0];
        lab2.font = [UIFont systemFontOfSize:20];
        lab2.textColor = [UIColor orangeColor];
        lab2.backgroundColor = [UIColor clearColor];
        [_scrView addSubview:lab2];
        
        rect = CGRectMake(20, 45, 280, 40);
        UILabel * lab3 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab3.text = [_wInfo.windArray objectAtIndex:0];
        lab3.font = [UIFont systemFontOfSize:18];
        lab3.textColor = [UIColor orangeColor];
        lab3.backgroundColor = [UIColor clearColor];
        [_scrView addSubview:lab3];
        
        
        rect = CGRectMake(5, 45+40, 310, 2);
        [self layoutSepImgView:_scrView wihtRect:rect];
    }
    
    {
        rect = CGRectMake(5,45+45, 310, 300);
        [self layoutWeatherCellView:_scrView withRect:rect];
    }
}



-(NSInteger)getWeekDay
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    
    NSDateComponents * dateC = [calendar components:flags fromDate:[NSDate date]];
    
    NSInteger weekDay = [dateC weekday];
    
    return weekDay;
}



-(void)getMaxMinTmp
{
    NSInteger max = -100;
    NSInteger min = 100;
    
    //test
    
    /*
    [_wInfo.tmpArray removeAllObjects];
    
    [_wInfo.tmpArray addObject:@"15℃~9℃"];
    [_wInfo.tmpArray addObject:@"18℃~11℃"];
    [_wInfo.tmpArray addObject:@"13℃~4℃"];
    [_wInfo.tmpArray addObject:@"10℃~4℃"];
    [_wInfo.tmpArray addObject:@"11℃~3℃"];
    [_wInfo.tmpArray addObject:@"10℃~0℃"];
    */
    
    
    for( NSInteger index = 0;index<6; ++ index )
    {
        //NSString * str = @"-12℃~16℃";
        
        NSString * str = [_wInfo.tmpArray objectAtIndex:index];
        
        BOOL falg1 = NO;//已经读完最低温度
        BOOL falg2 = NO;//最低温度为-
        BOOL falg3 = NO;//最高温度为-
        
        NSInteger tempMin = 0;
        NSInteger tempMax = 0;
        
        
        for( NSInteger len = 0; len < [str length]; ++ len )
        {
            char ch = [[str substringWithRange:NSMakeRange(len, 1)]characterAtIndex:0];
            
            if( ch == '-' )
            {
                if( !falg1 )
                {
                    falg2 = YES;
                }
                else
                {
                    falg3 = YES;
                }
                
                continue;
            }
            else if( ch >='0' && ch <= '9' )
            {
                if( !falg1)
                {
                    tempMin = tempMin*10 + ch - '0';
                }
                else
                {
                    tempMax = tempMax*10 + ch - '0';
                }
            }
            else
            {
                falg1 = YES;
            }
        }
        
        
        if( falg2 )
        {
            tempMin = 0-tempMin;
        }
        if( falg3 )
        {
            tempMax = 0-tempMax;
        }
        
        NSLog(@"tempMax:%d tempMin:%d",tempMax,tempMin);
        
        
       // if( falg3 )
        {
            if( tempMax< tempMin )
            {
                [self getMaxMinTmp2];
                return;
            }
            
            
        }
        
        
        if( tempMax > max)
        {
            max = tempMax;
        }
        
        if( tempMin < min )
        {
            min = tempMin;
        }
        
        
        NSLog(@"max:%d min:%d",tempMax,tempMin);
        
        
        maxTempArr[index] = tempMax;
        mixTempArr[index] = tempMin;
        
    }
    
    maxTmp = max;
    minTmp = min;
    
    NSLog(@"Min:%d Max:%d",min,max);
}



-(void)getMaxMinTmp2
{
    NSInteger max = -100;
    NSInteger min = 100;
    
    
    
    //test
    /*
    [_wInfo.tmpArray removeAllObjects];
    
    [_wInfo.tmpArray addObject:@"15℃~9℃"];
    [_wInfo.tmpArray addObject:@"18℃~11℃"];
    [_wInfo.tmpArray addObject:@"13℃~4℃"];
    [_wInfo.tmpArray addObject:@"10℃~4℃"];
    [_wInfo.tmpArray addObject:@"11℃~3℃"];
    [_wInfo.tmpArray addObject:@"10℃~0℃"];
    */
    
    for( NSInteger index = 0;index<6; ++ index )
    {
        NSString * str = [_wInfo.tmpArray objectAtIndex:index];
        
        BOOL falg1 = NO;//已经读完最低温度
        BOOL falg2 = NO;//最低温度为-
        BOOL falg3 = NO;//最高温度为-
        
        NSInteger tempMin = 0;
        NSInteger tempMax = 0;
        
        
        for( NSInteger len = 0; len < [str length]; ++ len )
        {
            char ch = [[str substringWithRange:NSMakeRange(len, 1)]characterAtIndex:0];
            
            if( ch == '-' )
            {
                if( !falg1 )
                {
                    falg2 = YES;
                }
                else
                {
                    falg3 = YES;
                }
                
                continue;
            }
            else if( ch >='0' && ch <= '9' )
            {
                if( !falg1)
                {
                   tempMax = tempMax*10 + ch - '0';
                }
                else
                {
                    tempMin = tempMin*10 + ch - '0';
                }
            }
            else
            {
                falg1 = YES;
            }
        }
        
        
        if( falg2 )
        {
            tempMax = 0-tempMax;
        }
        if( falg3 )
        {
            
            
            tempMin = 0-tempMin;
        }
        
        NSLog(@"tempMax:%d tempMin:%d",tempMax,tempMin);

        
        if( tempMax > max)
        {
            max = tempMax;
        }
        
        if( tempMin < min )
        {
            min = tempMin;
        }
        
        
        NSLog(@"max:%d min:%d",tempMax,tempMin);
        
        
        maxTempArr[index] = tempMax;
        mixTempArr[index] = tempMin;
    
    }

    maxTmp = max;
    minTmp = min;
      
    NSLog(@"Min:%d Max:%d",min,max);
}


-(void)initWindPic
{
    [_picDict setValue:@"w0" forKey:@"晴"];
    [_picDict setValue:@"w1" forKey:@"多云"];
    [_picDict setValue:@"w2" forKey:@"阴"];
    [_picDict setValue:@"w3" forKey:@"阵雨"];
    [_picDict setValue:@"w4" forKey:@"雷阵雨"];
    [_picDict setValue:@"w5" forKey:@"雷阵雨伴有冰雹"];
    [_picDict setValue:@"w6" forKey:@"雨夹雪"];
    [_picDict setValue:@"w7" forKey:@"小雨"];
    [_picDict setValue:@"w8" forKey:@"中雨"];
    [_picDict setValue:@"w9" forKey:@"大雨"];
    [_picDict setValue:@"w10" forKey:@"暴雨"];
    [_picDict setValue:@"w11" forKey:@"阵雪"];
    [_picDict setValue:@"w12" forKey:@"雪"];
    
}


-(void)layoutWeatherCellView:(UIView*)view withRect:(CGRect)rt
{
    //CGRect rect;
    
    #define TEMP_IMG_CELL_HEIGHT  150.0f
    
    NSInteger weekDay = [self getWeekDay]+1;
    NSInteger index = 0;

    UIView * subView = [[[UIView alloc]initWithFrame:rt]autorelease];
    [view addSubview:subView];

    
    [self getMaxMinTmp];
    
    
    NSInteger tempHeight = abs(maxTmp-minTmp);
    CGFloat pre = TEMP_IMG_CELL_HEIGHT/tempHeight;
    
    for( index = 0; index< 6; ++ index )
    {
        CGRect rect;
        
        NSLog(@"%d",(index+weekDay)%7);
        
        /*
        rect = CGRectMake(15+index*(35+15), 15, 35, 18);
        UIImageView *imgView1 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"day%d",(index+weekDay)%7]];
        [subView addSubview:imgView1];
         */
        
        rect = CGRectMake(15+index*(35+15), 15, 35, 18);
        UILabel * lab1 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab1.backgroundColor = [UIColor clearColor];
        lab1.font = [UIFont systemFontOfSize:14.0];
        
        if( (index+weekDay)%7 == 1 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周日"];
        }
        else if( (index+weekDay)%7 == 2 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周一"];
        }
        else if( (index+weekDay)%7 == 3 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周二"];
        }
        else if( (index+weekDay)%7 == 4 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周三"];
        }
        else if( (index+weekDay)%7 == 5 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周四"];
        }
        else if( (index+weekDay)%7 == 6 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周五"];
        }
        else if( (index+weekDay)%7 == 0 )
        {
            lab1.text = [NSString stringWithFormat:@"%@",@"周六"];
        }
        
        [subView addSubview:lab1];
        
        
        
        rect = CGRectMake(15+index*(35+15)-5, 15+18+12, 35,35 );
        UIImageView * imgView2 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        
        if ([_picDict objectForKey:[_wInfo.picArray objectAtIndex:index]])
        {
            imgView2.image = [UIImage imageNamed:[_picDict objectForKey:[_wInfo.picArray objectAtIndex:index]]];
        }
        else
        {
           imgView2.image = [UIImage imageNamed:@"w1"];
        }
        
        [subView addSubview:imgView2];
        
        
        CGFloat x = 15+index*(35+15)+5;
        CGFloat y = 15+18+12+35+10+abs(maxTmp - maxTempArr[index])*pre+10;
        CGFloat height = abs(maxTempArr[index]-mixTempArr[index])*pre;
        CGFloat widht = 20;
        
        
        rect = CGRectMake(x, y,widht, height);
        UIImageView * imgView3 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView3.image = [UIImage imageNamed:@"tempBar"];
        [subView addSubview:imgView3];
        
        
        rect = CGRectMake(x,y-15, 30, 15);
        
        UILabel * lab4 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab4.text = [NSString stringWithFormat:@"%d℃",maxTempArr[index]];
        lab4.backgroundColor = [UIColor clearColor];
        lab4.font = [UIFont systemFontOfSize:12];
        [subView addSubview:lab4];
        
        
        rect = CGRectMake(x,y+height+5, 30, 15);
        
        UILabel * lab5 = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab5.text = [NSString stringWithFormat:@"%d℃",mixTempArr[index]];
        lab5.backgroundColor = [UIColor clearColor];
        lab5.font = [UIFont systemFontOfSize:12];
        [subView addSubview:lab5];
        
    }

}

-(void)getWeatherData
{
    NSURL * url = [NSURL URLWithString:WEATHER_URL_STR];
    NSString * str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"weather:%@",str);
    
    NSDictionary * dict = [data objectFromJSONData];
    
    [_wInfo fromDict:dict];
    
    [self layoutView];
}


-(void)dealloc
{
    [_wInfo release];
    [_scrView release];
    
    [_picDict removeAllObjects];
    [_picDict release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
