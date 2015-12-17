//
//  ThemeManager.m
//  HCWeibo
//
//  Created by gj on 15/12/9.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager{
    NSDictionary *_themeConfigDic;//theme.plist 只有一个
    NSDictionary *_colorConfigDic; //config.plist 每个主题包有一个，记录 颜色名字对应的rgb值

}

//单例方法，在整个APP运行期间我们只需要一个对象
+ (instancetype)shareInstance{
    static ThemeManager *instance = nil;
    static  dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        //01 设置默认主题
      
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:ThemeNameKey];
        if (_themeName == nil) {
            _themeName = DefaultThemeName;
        }
        
        
        //02 读取主题配置文件： 主题名字 对应的 路径
        NSString *themeConfigPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfigDic = [NSDictionary dictionaryWithContentsOfFile:themeConfigPath];
        //NSLog(@"%@",_themeConfigDic);
        

        //03 加载颜色配置文件
        NSString *themePath = [self themePath];
        NSString *themeColorPath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfigDic = [NSDictionary dictionaryWithContentsOfFile:themeColorPath];
        
        
    }
    return  self;

}

- (void)setThemeName:(NSString *)themeName{
    
    if (![_themeName isEqualToString:themeName]) {
        //01 设置主题名字
        _themeName = [themeName copy];
        
        //02 重新加载颜色配置文件
        NSString *themePath = [self themePath];
        NSString *themeColorPath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfigDic = [NSDictionary dictionaryWithContentsOfFile:themeColorPath];
        
        
        //03 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
        
        //04 把主题名字保存到userDefaults（plist）文件中
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:ThemeNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
}


// cat  Skins/cat
// bluemoon Path/Hello/


//简单实现
//- (UIImage *)getThemeImage:(NSString *)imageName{
//    //cat
//    NSString *pathPrefix = @"Skins";
//   
//    NSString *imageFullName = [NSString stringWithFormat:@"%@/%@/%@",pathPrefix,_themeName,imageName];
//    NSLog(@"%@",imageFullName);
//    
//    UIImage *image = [UIImage imageNamed:imageFullName];
//    return image;
//        
//    
//}

- (UIImage *)getThemeImage:(NSString *)imageName{
    //01 获取主题包路径
    NSString *themePath = [self themePath];
    //02 拼接图片完整路径 stringByAppendingPathComponent 方法会加上反斜杠 /
    NSString *imageFullPath = [themePath stringByAppendingPathComponent:imageName];

    //03 获取图片对象
    
//    [UIImage imageNamed:<#(nonnull NSString *)#>]
    UIImage *image = [UIImage imageWithContentsOfFile:imageFullPath];
    return  image;
}

//通过颜色名字获得color对象
- (UIColor *)getThemeColor:(NSString *)colorName{

    //_colorConfigDic

    NSDictionary *rgbDic = [_colorConfigDic objectForKey:colorName];
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    NSNumber *alpha = rgbDic[@"alpha"];
    if (alpha == nil) {
        alpha = @1;
    }
    
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:[alpha floatValue]];

    return color;

}



//获取主题包的路径
- (NSString *)themePath{
    //01 获取资源包根目录路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    //02 在theme.plist 文件中找到对应的 子路径 Skins/cat
    NSString *subPath = [_themeConfigDic objectForKey:_themeName];
    
    //03 拼接出完整路径
    NSString *fullPath = [bundlePath stringByAppendingPathComponent:subPath];
    
    return fullPath; // /User/gj/xxx/Skins/cat

}






@end
