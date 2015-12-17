//
//  WeiboCell.m
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "WeiboCell.h"

#import "UIImageView+WebCache.h"


@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
    self.weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.weiboView];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setModel:(WeiboModel *)model{
//
//    if (_model != model) {
//        _model = model;
//        self.weiboView.weiboModel = _model;
//    
//        //需要重新布局子视图，然后在合适的时机layoutSubviews会被调用
//        [self setNeedsLayout];
//        
//    }
//
//}


- (void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame{
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        self.weiboView.layoutFrame = _layoutFrame;
    
        [self setNeedsLayout];
    }

    

}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    WeiboModel *_model = _layoutFrame.weiboModel;
    
    //01 用户名字
    _userNameLabel.text = _model.userModel.screen_name;
    
    //02 用户头像
    
    NSString *headImageString = _model.userModel.profile_image_url;

    NSURL *headImageUrl = [NSURL URLWithString:headImageString];
    
    [_headImageView sd_setImageWithURL:headImageUrl placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    //03 评论
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",_model.commentsCount];
    //04 转发
    _repostLabel.text = [NSString stringWithFormat:@"转发:%@",_model.repostsCount];
    
    //05 来源
    
    _sourceLabel.text = _model.source;
    
#warning 整个weiboView的 frame在这里设置
    _weiboView.frame = _layoutFrame.frame;
    
}





@end
