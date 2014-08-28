//
//  ListViewCell.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-10.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataStruct.h"

@interface ListViewCell : UIView
{
    DZDPListInfo *_info;
}

- (id)initWithFrame:(CGRect)frame withData:(DZDPListInfo*)info;

@end
