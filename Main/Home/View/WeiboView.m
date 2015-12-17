//
//  WeiboView.m
//  HCWeibo
//
//  Created by gj on 15/12/11.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "Common.h"

@implementation WeiboView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _createSubViews];
    }
    return  self;
}


- (void)_createSubViews{
    //1、原创微博内容
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
//    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.linespace = 5.0f;
    _textLabel.wxLabelDelegate = self;
    
    
    //2、转发微博内容
    _repostTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
//    _repostTextLabel.font = [UIFont systemFontOfSize:14];
    _repostTextLabel.linespace = 5.0f;
    _repostTextLabel.wxLabelDelegate = self;
    
    //3、背景图片
    _bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.topCapHeight = 10;
    _bgImageView.leftCapWidth = 10;
    
    _bgImageView.imageName = @"timeline_rt_border_9.png";
    
    

    //4、微博图片
    _imageView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
  
    [self addSubview:_bgImageView];
    
    [self addSubview:_textLabel];
   
    
    [self addSubview:_repostTextLabel];
    [self addSubview:_imageView];
 
}

//
//- (void)setWeiboModel:(WeiboModel *)weiboModel{
//    if (_weiboModel != weiboModel) {
//        _weiboModel = weiboModel;
//        [self setNeedsLayout];
//    }
//}


- (void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame{
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;

        
        [self setNeedsLayout];
    }
    
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    WeiboModel *_weiboModel = _layoutFrame.weiboModel;
    
    
    
    
    CGFloat weiboFontSize = FontSize_Weibo(_layoutFrame.isDetail);
    CGFloat reWeiboFontSize = FontSize_ReWeibo(_layoutFrame.isDetail);
    
    //01 整个weiboView的设置
    //self.frame = _layoutFrame.frame;
    

    //02 原创微博文字设置
   
    
    _textLabel.font = [UIFont systemFontOfSize:weiboFontSize];
    _textLabel.frame = _layoutFrame.textFrame;
    _textLabel.text = _weiboModel.text;
    
    
    //03 判断是否有转发
        
    if (_weiboModel.repostWeiboModel == nil) {//无转发
        _repostTextLabel.hidden = YES;
        _bgImageView.hidden = YES;
        
        //如果有图片
        if (_weiboModel.thumbnailImage != nil) {
            _imageView.hidden = NO;
            _imageView.frame = _layoutFrame.imageFrame;
            
            NSString *thumbImageStr = _weiboModel.thumbnailImage;
            //原始图片的链接
            _imageView.fullImageUrl = _weiboModel.originalImage;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:thumbImageStr]];
            
        }else{
        
            _imageView.hidden = YES;
        }
        

        
    }else{//有转发
 
        //>>01 背景图片
        _bgImageView.hidden = NO;
        _bgImageView.frame = _layoutFrame.bgImageFrame;
        //>>02 转发文字
        _repostTextLabel.hidden = NO;
        _repostTextLabel.font = [UIFont systemFontOfSize:reWeiboFontSize];
        _repostTextLabel.frame = _layoutFrame.rTextFrame;
        _repostTextLabel.text = _weiboModel.repostWeiboModel.text;
        //>>03 转发图片
        if (_weiboModel.repostWeiboModel.thumbnailImage != nil) {
            _imageView.hidden = NO;
            _imageView.frame = _layoutFrame.imageFrame;
            NSString *thumbImageStr = _weiboModel.repostWeiboModel.thumbnailImage;
            
            //原始图片链接
            _imageView.fullImageUrl = _weiboModel.repostWeiboModel.originalImage;
            
            [_imageView sd_setImageWithURL:[NSURL URLWithString:thumbImageStr]];
        
            
        }else{
        
            _imageView.hidden = YES;
        }
        
    
    }
    
    //是有微博图片的
    if (_imageView.hidden == NO) {
        NSString *extersion;
    
        _imageView.gifIconView.frame = CGRectMake(_imageView.width-24, _imageView.height-14, 24, 14);
        
        //判断是否是转发微博的图片
        if (_weiboModel.repostWeiboModel == nil) {
            extersion = [_weiboModel.thumbnailImage pathExtension];

        }else{
        
            extersion = [_weiboModel.repostWeiboModel.thumbnailImage pathExtension];
        }
        
        if ([extersion isEqualToString:@"gif"]) {
            _imageView.gifIconView.hidden = NO;
            
        }else{
            _imageView.gifIconView.hidden = YES;
        
        }
    
    
    }
    
    
    
    
    

    
    
}


#pragma  mark - WXLable Delegate
//返回用于处理高亮文字的正则表达式
- (NSString*)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    //需要高亮的文字： @用户   链接https://  #话题#
    NSString *regex1 = @"@\\w+";//用户
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;


}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{

    return [UIColor redColor];

}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor blueColor];

}

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{

    NSLog(@"TouchEnd %@",context);

}
//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
   NSLog(@"TouchBegin %@",context);

}

@end
