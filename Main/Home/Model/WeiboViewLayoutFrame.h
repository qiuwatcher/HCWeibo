//
//  WeiboViewLayoutFrame.h
//  HCWeibo
//
//  Created by gj on 15/12/11.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface WeiboViewLayoutFrame : NSObject

@property (nonatomic,assign) CGRect frame;//weiboView 布局
@property (nonatomic,assign) CGRect textFrame;//微博布局
@property (nonatomic,assign) CGRect rTextFrame;//转发微博布局
@property (nonatomic,assign) CGRect imageFrame;//微博图片布局
@property (nonatomic,assign) CGRect bgImageFrame;//背景图片布局


@property (nonatomic,strong) WeiboModel *weiboModel;
@property (nonatomic,assign) BOOL isDetail;//判断是否是详情页面



@end
