//
//  ZoomImageView.h
//  HCWeibo
//
//  Created by gj on 15/12/16.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Common.h"
#import "UIViewExt.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>


@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    NSURLConnection *_connection;//网络连接
    NSMutableData *_data;//用来存放网络下载数据
    double _dataLength;//数据总大小
    MBProgressHUD *_hud;//进度条
    
    
    
}

@property (nonatomic,copy) NSString *fullImageUrl;
@property (nonatomic,strong)UIImageView *gifIconView;

@end
