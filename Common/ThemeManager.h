//
//  ThemeManager.h
//  HCWeibo
//
//  Created by gj on 15/12/9.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//主题切换通知名字
#define  kThemeDidChangeNotification  @"kThemeDidChangeNotification"
#define ThemeNameKey @"ThemeNameKey" //用来存到userDefaults里的key
#define DefaultThemeName @"猫爷" //默认主题名字

@interface ThemeManager : NSObject
//主题名字
@property (nonatomic,copy) NSString *themeName;



//单例方法（类方法）
//+ (ThemeManager *)shareInstance;
+ (instancetype)shareInstance;

- (UIImage *)getThemeImage:(NSString *)imageName;

- (UIColor *)getThemeColor:(NSString *)colorName;



@end
