//
//  BaseNavViewController.m
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "BaseNavViewController.h"
#import "ThemeManager.h"

#import "Common.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//从xib文件中直接创建对象
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
       // NSLog(@"initWithCoder");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeDidChangeNotification object:nil];

    }
    return  self;
}

//手动代码创建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)loadThemeResources{
   // mask_titlebar.png
    NSString *navBgImageName = @"mask_titlebar.png";
    if (ios7) {
        navBgImageName = @"mask_titlebar64.png";
    }
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    //01 设置导航栏背景图片
    UIImage *navBgImage = [manager getThemeImage:navBgImageName];

    [self.navigationBar setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
    
    //02 设置导航栏字体颜色
    //>>1 直接建立控件（Lable）覆盖掉title
    //>>2 设置属性 头文件 NSAttributedString.h
    UIColor *navTitleColor = [manager getThemeColor:@"Mask_Title_color"];
//    Timeline_Content_color
//    Mask_Title_color
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:navTitleColor};
    
   
// 03 导航栏item按钮 字体颜色
    self.navigationBar.tintColor = navTitleColor;


    

}

//loadThemeResources

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadThemeResources];

   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
