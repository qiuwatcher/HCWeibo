//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface UserView : UIView
@property (nonatomic,strong) WeiboModel *weiboModel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;


@end
