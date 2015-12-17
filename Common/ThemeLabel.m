//
//  ThemeLabel.m
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel
- (void)dealloc{
    //ARC中不调用super
    //[super dealloc];
    //移除通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
    }
    return self;

}

- (void)awakeFromNib{
    [super awakeFromNib];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
}

- (void)setColorName:(NSString *)colorName{
    if (![_colorName isEqualToString:colorName]) {
        _colorName = [colorName copy];
        self.textColor = [[ThemeManager shareInstance]getThemeColor:self.colorName];
    }
    
}



- (void)themeDidChange{
    
    self.textColor = [[ThemeManager shareInstance]getThemeColor:self.colorName];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
