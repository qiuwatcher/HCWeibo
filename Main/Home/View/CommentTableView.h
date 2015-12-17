//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UserView.h"
#import "CommentCell.h"


@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    //用户视图
    UserView *_userView;
    //微博视图
    WeiboView *_weiboView;
    
    //头视图
    UIView *_theTableHeaderView;
}
@property(nonatomic,strong)NSArray *commentDataArray;//评论数据model  列表
@property(nonatomic,strong)WeiboModel *weiboModel;//微博model

@property(nonatomic,assign)NSInteger commentCount;//评论个数



@end

