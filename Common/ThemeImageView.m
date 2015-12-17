//
//  ThemeImageView.m
//  HCWeibo
//
//  Created by gj on 15/12/9.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView
- (void)dealloc{
    //ARC中不调用super
    //[super dealloc];
    //移除通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _topCapHeight = 0.0;
        _leftCapWidth = 0.0;
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
    }
    return self;

}


- (void)awakeFromNib{
    [super awakeFromNib];
    _topCapHeight = 0.0;
    _leftCapWidth = 0.0;
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
}

//接收到通知以后执行的动作：切换图片
- (void)themeDidChange{
    //重新获取图片，imageName,拼接路径
    //manager 中提供接口：通过图片名字得到图片
    
    [self loadImage];
    
}

- (void)loadImage{

    //01 得到单例对象
    ThemeManager *manager = [ThemeManager shareInstance];
    //02 获取图片
    UIImage *image = [manager getThemeImage:_imageName];

    
    self.image = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
    
    
}

- (void)setImageName:(NSString *)imageName{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self loadImage];
        
    }
}



@end
