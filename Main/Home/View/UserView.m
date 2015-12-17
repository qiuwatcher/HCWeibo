//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "UIViewExt.h"

@implementation UserView


- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImageView.layer.borderWidth = 1;
    _userImageView.layer.cornerRadius = _userImageView.width/2;
    _userImageView.layer.masksToBounds = YES;
    
    //1.用户头像
    NSString *imgURL = self.weiboModel.userModel.avatar_large;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    
    //2.昵称
    _nameLabel.text = self.weiboModel.userModel.screen_name;
    

    
    //3.来源
    _sourceLabel.text = self.weiboModel.source;
}



@end
