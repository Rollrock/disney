//
//  ListViewCell.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-10.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "ListViewCell.h"
#import "dataStruct.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#define IMAGE_WIDTH 90
#define IMAGE_HEIGHT 68

#define VIEW_WIDHT 300
#define VIEW_HEIGHT 80

#define SHOP_NAME_WIDHT 200


@implementation ListViewCell

- (id)initWithFrame:(CGRect)frame withData:(DZDPListInfo*)info
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self layoutView:info];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //[self layoutView];
    }
    return self;
}


-(void)layoutView:(DZDPListInfo*)info
{
    CGRect rect;
    
    rect = CGRectMake(5, 5, IMAGE_WIDTH, IMAGE_HEIGHT);
    UIImageView * imgView1 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    //imgView1.image = [UIImage imageNamed:@"1"];
    
    [imgView1 setImageWithURL:[NSURL URLWithString:info.shopUrl]];
    
    [self addSubview:imgView1];
    
    rect = CGRectMake(5+IMAGE_WIDTH+10, 8, SHOP_NAME_WIDHT, 15);
    UILabel * lab2 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab2.text = info.shopName;
    [self addSubview:lab2];
    
    
    
    rect = CGRectMake(5+IMAGE_WIDTH+10, 8+15+8, 82, 16);
    UIImageView * imgView3 = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    //imgView3.image = [UIImage imageNamed:@"16_35star"];
    [imgView3 setImageWithURL:[NSURL URLWithString:info.shopStarUrl]];
    [self addSubview:imgView3];
    
    rect = CGRectMake(5+IMAGE_WIDTH+10+82+5, 8+15+8, 100, 16);
    UILabel * lab4 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab4.font = [UIFont systemFontOfSize:14];
    lab4.text = info.avgPrice;
    [self addSubview:lab4];
    
    rect = CGRectMake(5+IMAGE_WIDTH+10, 8+15+8+16+10, 130, 15);
    UILabel * lab5 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab5.font = [UIFont systemFontOfSize:14];
    lab5.text = info.shopKeyWord;
    [self addSubview:lab5];
    
    rect = CGRectMake(5+IMAGE_WIDTH+10 +130+15, 8+15+8+16+10, 50, 15);
    UILabel * lab6 = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab6.font = [UIFont systemFontOfSize:14];
    lab6.text = info.dist;
    [self addSubview:lab6];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
