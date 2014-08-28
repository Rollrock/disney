#import "dataStruct.h"

#define SetSTR(dict,keypath,property) do \
{ \
	NSString* src = [dict valueForKeyPath:keypath]; \
    if([src isKindOfClass:NSString.class]) { \
	self.property = (src)?src:@""; \
	} else { \
	self.property = @""; \
    }\
} while (0);

#define SETSTRFORDICT(dict, key, property) do \
{ \
	NSString* temp = self.property;\
	if(temp)\
	{\
		[dict setObject:temp forKey:key];\
	}\
	else\
	{\
		[dict setObject:@"" forKey:key];\
	}\
} while (0);





@implementation AboutAdvInfo

-(void)dealloc
{
    self.title = nil;
    self.url = nil;
    
    [super dealloc];
}

-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"title", title);
    SetSTR(dict, @"url", url);
    
    NSLog(@"title:%@  url:%@",self.title,self.url);
}

@end



@implementation SceneryDetailInfo

-(void)dealloc
{
    self.title = nil;
    self.desc = nil;
    
    [self.picUrlArry removeAllObjects];
    
    
    [super dealloc];
}


-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"title", title);
    SetSTR(dict, @"desc", desc);
    
    
    self.picUrlArry = [[[NSMutableArray alloc]init]autorelease];
    
    NSArray * arr = [dict objectForKey:@"img"];
    
    if( [arr isKindOfClass:[NSArray class]] )
    {
        for( NSDictionary * subDic in arr )
        {
            if( [subDic isKindOfClass:[NSDictionary class]] )
            {
                NSString * str = [subDic objectForKey:@"imgUrl"];
                
                NSLog(@"strUrl:%@",str);
                
                [self.picUrlArry addObject:str];
            }
        }
    }
}

@end




@implementation DZDPComment

-(void)dealloc
{
    self.name = nil;
    self.starUrl = nil;
    self.comment = nil;
    
    [super dealloc];
}

-(void)fromDict:(NSDictionary*)dict
{
    SetSTR(dict, @"user_nickname", name);
    SetSTR(dict, @"rating_s_img_url", starUrl);
    SetSTR(dict, @"text_excerpt", comment);
    
    NSLog(@"~~~name:%@  -%@--%@",_name,_starUrl,_comment);
}

@end



@implementation DZDPShopDetailInfo

-(void)dealloc
{
    self.shopName = nil;
    self.shopUrl= nil;
    self.shopStarUrl = nil;
    self.shopAddr = nil;
    self.tel = nil;
    
    [super dealloc];
}

-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"name", shopName);
    SetSTR(dict, @"telephone", tel);
    SetSTR(dict, @"s_photo_url", shopUrl);
    SetSTR(dict, @"rating_s_img_url", shopStarUrl);
    SetSTR(dict, @"address", shopAddr);
    
    
    NSNumber * avgP = [dict objectForKey:@"avg_price"];
    
    
    NSNumber * taste = [dict objectForKey:@"product_grade"];
    NSNumber * service = [dict objectForKey:@"service_grade"];
    NSNumber * env = [dict objectForKey:@"decoration_grade"];
    
    
    self.avgPrice = [avgP intValue];
    self.taste = [taste intValue];
    self.service = [service intValue];
    self.env = [env intValue];
    
    
    NSLog(@"%@-%@-%@-%@-%@-%d-%d-%d-%d",_shopName,_tel,_shopUrl,_shopStarUrl,_shopAddr,_avgPrice,_taste,_service,_env);
}

@end







@implementation DZDPListInfo


-(void)dealloc
{
    self.dist = nil;
    self.shopKeyWord = nil;
    self.shopName = nil;
    self.shopUrl = nil;
    self.shopStarUrl = nil;
    self.avgPrice = nil;
    
    [super dealloc];
}

-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"name", shopName);
    SetSTR(dict, @"telephone", shopKeyWord);
    //SetSTR(dict, @"distance", dist);
    SetSTR(dict, @"s_photo_url", shopUrl);
    SetSTR(dict, @"rating_s_img_url", shopStarUrl);
    //SetSTR(dict, @"avg_price", avgPrice);
    
    NSNumber * distance = [dict objectForKey:@"distance"];
    NSNumber * avgP = [dict objectForKey:@"avg_price"];
    NSNumber * busId = [dict objectForKey:@"business_id"];
    
    self.dist = [NSString stringWithFormat:@"%d米", [distance intValue]];
    self.avgPrice = [NSString stringWithFormat:@"人均%d元",[avgP intValue]];
    self.busId = [busId intValue];
}

@end



@implementation WeatherInfo

-(void)dealloc
{
    /*
    [self.tmpArray removeAllObjects];
    [self.tmpArray release];
    
    [self.wethArray removeAllObjects];
    [self.wethArray release];
    
    [self.windArray removeAllObjects];
    [self.windArray release];
    
    [self.picArray removeAllObjects];
    [self.picArray release];
    */
    
    [super dealloc];
}


-(void)fromDict:(NSDictionary *)dict
{
    self.tmpArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    self.wethArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    self.windArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    self.picArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    
    NSDictionary * d = [dict objectForKey:@"weatherinfo"];
    
    if( [d isKindOfClass:[NSDictionary class]])
    {
        NSInteger index = 0;
        
        for( index = 1; index < 7; ++ index )
        {
            NSString * str = [d objectForKey:[NSString stringWithFormat:@"temp%d",index]];
            [self.tmpArray addObject:str];
            NSLog(@"temp:%@",str);
        }
        
        for( index = 1; index < 7; ++ index )
        {
            NSString * str = [d objectForKey:[NSString stringWithFormat:@"weather%d",index]];
            [self.wethArray addObject:str];
            NSLog(@"wether:%@",str);
        }
        
        for( index = 1; index < 7; ++ index )
        {
            NSString * str = [d objectForKey:[NSString stringWithFormat:@"wind%d",index]];
            [self.windArray addObject:str];
            NSLog(@"wind:%@",str);
        }
        
        for( index = 1; index < 7; ++ index )
        {
            NSString * str = [d objectForKey:[NSString stringWithFormat:@"img_title%d",index*2-1]];
            [self.picArray addObject:str];
        }
    }
}


@end




@implementation TourGuideInfo

-(void)dealloc
{
    self.imgUrl = nil;
    self.title = nil;
    self.desc = nil;
    self.detailUrl = nil;
    
    [super dealloc];
}

-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"imageUrl", imgUrl);
    SetSTR(dict, @"title", title);
    SetSTR(dict, @"desc", desc);
    SetSTR(dict, @"detailUrl", detailUrl);
    
    NSLog(@"%@-%@-%@-%@",_detailUrl,_imgUrl,_title,_desc);
}

@end




@implementation IntroInfo


-(void)fromDict:(NSDictionary *)dict
{
    self.imgUrlArray = [[[NSMutableArray alloc]initWithCapacity:1]autorelease];
    self.descArray = [[[NSMutableArray alloc]initWithCapacity:1]autorelease];
    
    NSArray * arry = [dict objectForKey:@"imgUrlArray"];
    
    if( [arry isKindOfClass:[NSArray class]])
    {
        for( NSDictionary * subDict in arry )
        {
            if( [subDict isKindOfClass:[NSDictionary class]])
            {
                NSString * str = [subDict objectForKey:@"url"];
                [self.imgUrlArray addObject:str];
                
                NSLog(@"str---%@",str);
            }
        }
    }
    
    arry = [dict objectForKey:@"desc"];
    
    if( [arry isKindOfClass:[NSArray class]])
    {
        for( NSDictionary * subDict in arry )
        {
            if( [subDict isKindOfClass:[NSDictionary class]])
            {
                NSString * str = [subDict objectForKey:@"info"];
                [self.descArray addObject:str];
                NSLog(@"desc:%@",str);
            }
        }
    }
}

-(void)dealloc
{
    /*
    [self.imgUrlArray removeAllObjects];
    [self.imgUrlArray release];
    
    [self.descArray removeAllObjects];
    [self.descArray release];
    */
    
    [super dealloc];
}

@end


@implementation ProductInfo
@synthesize ptaobaourl, imgUrl, psales, pid, pprice, desc, pname, pcateg, ppicurl_b, ppicurl_s;

- (void)dealloc
{
    self.ptaobaourl = nil;
	self.imgUrl = nil;
	self.pid = nil;
	self.desc = nil;
	self.pname = nil;
	self.pprice = nil;
	self.psales = nil;
	self.pcateg = nil;
	self.ppicurl_b = nil;
	self.ppicurl_s = nil;
    [super dealloc];
}

-(void) fromDict:(NSDictionary*) dict
{
	SetSTR(dict, @"pid", pid);
	SetSTR(dict, @"pname", pname);
	SetSTR(dict, @"pprice", pprice);
	SetSTR(dict, @"psales", psales);
	SetSTR(dict, @"pcateg", pcateg);
	SetSTR(dict, @"ptaobaourl", ptaobaourl);
	SetSTR(dict, @"ppicurl_b", ppicurl_b);
	SetSTR(dict, @"ppicurl_s", ppicurl_s);
}

-(void) toDict:(NSMutableDictionary*) dict
{
	SETSTRFORDICT(dict, @"pid", pid);
	SETSTRFORDICT(dict, @"pname", pname);
	SETSTRFORDICT(dict, @"pprice", pprice);
	SETSTRFORDICT(dict, @"psales", psales);
	SETSTRFORDICT(dict, @"pcateg", pcateg);
	SETSTRFORDICT(dict, @"ptaobaourl", ptaobaourl);
	SETSTRFORDICT(dict, @"ppicurl_b", ppicurl_b);
	SETSTRFORDICT(dict, @"ppicurl_s", ppicurl_s);
}

@end
