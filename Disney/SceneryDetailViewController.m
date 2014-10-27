//
//  SceneryDetailViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-22.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "SceneryDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "GADBannerView.h"
#import "dataStruct.h"
#import "JSONKit.h"


#define Scenery_DETAIL_IMAGE_WIDTH 310.0f
#define Scenery_DETAIL_IMAGE_HEIGHT 200.0f

@interface SceneryDetailViewController ()
{
    NSMutableData * _data;
    NSURLConnection * _conn;
    
    SceneryDetailInfo * _info;
}
@end

@implementation SceneryDetailViewController

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
    
    //[self layoutView];
    
    _info = [[SceneryDetailInfo alloc]init];
    
    [self parseData];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)layoutView
{
    
    CGFloat height = 0;
    
    CGRect rect;
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    UIScrollView * scrView = [[[UIScrollView alloc]initWithFrame:rect]autorelease];
    [self.view addSubview:scrView];
    
    
    for( NSInteger index = 0; index < [_info.picUrlArry count]; ++ index )
    {
        rect = CGRectMake(5, (5 + Scenery_DETAIL_IMAGE_HEIGHT) * index, Scenery_DETAIL_IMAGE_WIDTH, Scenery_DETAIL_IMAGE_HEIGHT);
        UIImageView * imgView1 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        //[imgView1 setImageWithURL:[NSURL URLWithString:@"http://i3.dpfile.com/pc/0ff70e6d8e3fc91379ea3470966116fb(278x200)/thumb.jpg"]];
        //[imgView1 setImageWithURL:[NSURL URLWithString: [_info.picUrlArry objectAtIndex:index]]];
        
        NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[_info.picUrlArry objectAtIndex:index]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        imgView1.image = image;
        
        [scrView addSubview:imgView1];
    }
    

    height = ([_info.picUrlArry count] )* (Scenery_DETAIL_IMAGE_HEIGHT + 5 );
    
    
    rect = CGRectMake(5, 5+height, 310, 100);
    GADBannerView *adView2 = [[[GADBannerView alloc]initWithFrame:rect]autorelease];
    adView2.adUnitID = ADMOB_ID;//调用你的id
    adView2.rootViewController = self;
    [scrView addSubview:adView2];
    [adView2 loadRequest:[GADRequest request]];
    
    rect = CGRectMake(5, 5+height+100, 310, 20);
    UILabel * labTitle3 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    //labTitle3.text = @"狮子王";
    labTitle3.text = _info.title;
    labTitle3.backgroundColor = [UIColor clearColor];
    [scrView addSubview:labTitle3];
    
    NSString * str = _info.desc;
    
    rect = CGRectMake(5, 5+height+100+20, 310, 0);
    UITextView * textView4 = [[[UITextView alloc]initWithFrame:rect]autorelease];
    textView4.text = str;
    textView4.editable = NO;
    textView4.scrollEnabled = NO;
    textView4.font = [UIFont systemFontOfSize:13];
    //textView4.backgroundColor = [UIColor redColor];
    [scrView addSubview:textView4];
    [self setTextViewFrame:textView4];
    
    scrView.contentSize = CGSizeMake(320, 5+height+100+20 + textView4.frame.size.height + 20);

}



- (void)setTextViewFrame:(UITextView *)textView
{
    //http://stackoverflow.com/questions/19028743/ios7-uitextview-contentsize-height-alternative
    
    /*  before  ios7
     CGFloat fixedWidth = textView.frame.size.width;
     CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
     CGRect newFrame = textView.frame;
     newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
     textView.frame = newFrame;
     */
    
    // ios7
    
    /*
    CGRect txtFrame = textView.frame;
    CGFloat textViewContentHeight = txtFrame.size.height =[[NSString stringWithFormat:@"%@\n  ",textView.text]
                                                           boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height;
    
    txtFrame.size.height = textViewContentHeight;
    
    textView.frame = txtFrame;
     */
    
    /*
    CGFloat width = textView.bounds.size.width - 2.0 * textView.textContainer.lineFragmentPadding;
    
    NSDictionary *options = @{ NSFontAttributeName: textView.font };
    CGRect boundingRect = [textView.text boundingRectWithSize:CGSizeMake(width, NSIntegerMax)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:options context:nil];
    
    boundingRect.size.height += textView.textContainerInset.top + textView.textContainerInset.bottom;
    
    boundingRect.origin.x = textView.frame.origin.x;
    boundingRect.origin.y = textView.frame.origin.y;
    
    textView.frame = boundingRect;
     */
    
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    CGRect rect = textView.frame;
    rect.size.height = textViewSize.height;
    
    textView.frame = rect;
    
}



-(void)parseData
{
    //NSString *documentsDirectory =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    //NSString* path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,self.sceneryName];
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_info.txt",self.sceneryName]];
    
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict = [data objectFromJSONData];
    
    NSLog(@"dict:%@",dict);
    
    [_info fromDict:dict];
    
    [self layoutView];
    
}



-(void)dealloc
{
    [_data release];
    [_conn release];
    
    [_info release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
