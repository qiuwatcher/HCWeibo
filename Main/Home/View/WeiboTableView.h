//
//  WeiboTableView.h
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCell.h"


@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataArray;


@end
