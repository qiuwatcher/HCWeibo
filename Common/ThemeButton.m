//
//  ThemeButton.m
//  HCWeibo
//
//  Created by gj on 15/12/9.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//
#import "ThemeManager.h"
#import "ThemeButton.h"

@implementation ThemeButton

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
    }
    return  self;
    
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
}

- (void)setNormalImageName:(NSString *)normalImageName{
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = [normalImageName copy];
        [self  loadImage];
    }


}


- (void)themeDidChange{
    
    [self loadImage];

}

- (void)loadImage{

    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *normalImage = [manager getThemeImage:self.normalImageName];
    [self setImage:normalImage forState:UIControlStateNormal];
}




@end
