#import <Foundation/Foundation.h>

#import "GoogleMobileAds/GADInterstitial.h"
#import "GoogleMobileAds/GADBannerView.h"

//#define DEVICE_VER_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES:NO)


#define DEVICE_VER    ([[[UIDevice currentDevice] systemVersion] floatValue])

#define DEVICE_VER_7  (((DEVICE_VER >=7.0) && (DEVICE_VER <8.0)) ?YES:NO)
#define DEVICE_VER_8  (((DEVICE_VER >=8.0) && (DEVICE_VER <9.0)) ?YES:NO)
#define DEVICE_VER_OVER_7 ((DEVICE_VER >=7.0)?YES:NO)

#define NAVIGATION_BAR_HEIGHT 44.0f
#define CUSTOM_TAB_BAR_HEIGHT 60.0f
#define CUSTOM_TAB_BAR_OFFSET 11.0f //这里的11是因为中间center与其他四个tabitem的偏移

#define STATUS_BAR_HEIGHT 0.0f


#if TARGET_IPHONE_SIMULATOR
    #define TARGET_IPHONE 0
#elif TARGET_OS_IPHONE
    #define TARGET_IPHONE 1
#endif


#define ADMOB_ID  @"ca-app-pub-3058205099381432/8591538347"


#define SHOW_ADV_YEAR  2024
#define SHOW_ADV_MONTH  12
#define SHOW_ADV_DAY    1


typedef enum
{
    DATA_TYPE_HOTEL,
    DATA_TYPE_EAT
    
}SECOND_VIEW_DATA_TYPE;


//@import GoogleMobileAds;
@class GADBannerView;

//////////////////////////////////////////////////////////////////
@interface ProductInfo : NSObject
@property(retain) NSString* pid;
@property(retain) NSString* pname;
@property(retain) NSString* ptaobaourl;
@property(retain) NSString* imgUrl;
@property(retain) NSString* psales;
@property(retain) NSString* pprice;
@property(retain) NSString* desc;
@property(retain) NSString* pcateg;
@property(retain) NSString* ppicurl_b;
@property(retain) NSString* ppicurl_s;
-(void) fromDict:(NSDictionary*) dict;
-(void) toDict:(NSMutableDictionary*) dict;
@end
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


@interface AboutAdvInfo : NSObject
@property(retain) NSString * title;
@property(retain) NSString * url;

-(void)fromDict:(NSDictionary*)dict;

@end


//////////////////////////////////////////////////////////////////


@interface SceneryDetailInfo : NSObject

@property(retain) NSMutableArray * picUrlArry;
@property(retain) NSString * title;
@property(retain) NSString * desc;

-(void)fromDict:(NSDictionary*)dict;

@end


//////////////////////////////////////////////////////////////////

//用户点评
@interface DZDPComment : NSObject

@property(retain) NSString * name;
@property(retain) NSString * starUrl;
@property(retain) NSString * comment;

-(void)fromDict:(NSDictionary*)dict;
@end



//////////////////////////////////////////////////////////////////

@interface DZDPShopDetailInfo : NSObject
@property(retain) NSString * shopName;
@property(retain) NSString * shopUrl;
@property(retain) NSString * shopStarUrl;
@property(retain) NSString * shopAddr;
@property(retain) NSString * tel;
@property(assign) NSInteger avgPrice;
@property(assign) NSInteger taste;
@property(assign) NSInteger service;
@property(assign) NSInteger env;
-(void)fromDict:(NSDictionary*)dict;
@end

//////////////////////////////////////////////////////////////////

@interface DZDPListInfo : NSObject
@property(retain) NSString * shopUrl;
@property(retain) NSString * shopName;
@property(retain) NSString * shopStarUrl;
@property(retain) NSString * shopKeyWord;
@property(retain) NSString * avgPrice;
@property(retain) NSString * dist;
@property(assign) NSInteger busId;

-(void)fromDict:(NSDictionary*)dict;

@end






@interface WeatherInfo : NSObject
@property(retain) NSMutableArray * tmpArray;
@property(retain) NSMutableArray * wethArray;
@property(retain) NSMutableArray * windArray;
@property(retain) NSMutableArray * picArray;

-(void)fromDict:(NSDictionary*)dict;
@end




@interface TourGuideInfo : NSObject

@property(retain) NSString * title;
@property(retain) NSString * desc;
@property(retain) NSString * imgUrl;
@property(retain) NSString * detailUrl;
-(void)fromDict:(NSDictionary*)dict;

@end


@interface IntroInfo : NSObject
@property(retain) NSMutableArray * imgUrlArray;//图片URL
// 0 描述   1时间   2门票价格
@property(retain) NSMutableArray * descArray;//

-(void)fromDict:(NSDictionary*)dict;

@end

