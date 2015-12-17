//
//  WeiboCell.h
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiboViewLayoutFrame.h"

@interface WeiboCell : UITableViewCell

//@property (nonatomic,strong)WeiboModel *model;
@property (nonatomic,strong)WeiboViewLayoutFrame  *layoutFrame;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView; //头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//用户名字
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;//评论
@property (weak, nonatomic) IBOutlet UILabel *repostLabel;//转发
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;//微博来源


@property (nonatomic,strong)WeiboView *weiboView; //weibo视图



@end
