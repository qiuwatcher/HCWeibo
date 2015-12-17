//
//  MainTabBarController.m
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "MainTabBarController.h"
#import "Common/Common.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController{
    ThemeImageView *_tabBgImageView;
    ThemeImageView *_tabArrowImageView;
    
    ThemeImageView *_badgeView; //提示未读消息
    ThemeLabel *_badgeLabel;
    
    
}

//底部button点击事件，切换视图
- (void)buttonSelected:(UIButton *)button{

    
    [UIView animateWithDuration:0.3 animations:^{
        _tabArrowImageView.center = button.center;
    }];
    
    self.selectedIndex = button.tag;
    
    

}

- (void)_createSubviewController{
    
    NSArray  *names =  @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSArray *chsNames = @[@"主页",@"消息",@"个人",@"发现",@"更多"];
    
    NSMutableArray *navArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *name in names) {
        
           UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
           UINavigationController *nav = [storyBoard instantiateInitialViewController];
            nav.topViewController.title = chsNames[i++];
            [navArray addObject:nav];
        
    }
    self.viewControllers = navArray;

}


//NSArray *imgNames = @[
//                      @"Skins/cat/home_tab_icon_1.png",
//                      @"Skins/cat/home_tab_icon_2.png",
//                      @"Skins/cat/home_tab_icon_3.png",
//                      @"Skins/cat/home_tab_icon_4.png",
//                      @"Skins/cat/home_tab_icon_5.png",
//                      ];
//@"Skins/cat/mask_navbar.png";	 //背景
//@"Skins/cat/home_bottom_tab_arrow.png";//按钮



- (void)_customTabBar{
//    uitabbarbutton
    //01 移除tabBar 上的所有按钮
    for (UIView *view in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    
    //02 TabBar背景图片
    _tabBgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, -6, kScreenWidth, 55)];
    _tabBgImageView.imageName = @"mask_navbar.png";
    
   
    //[UIScreen mainScreen].bounds.size.width
    [self.tabBar addSubview:_tabBgImageView];
    
    NSArray *imgNames = @[
                          @"home_tab_icon_1.png",
                          @"home_tab_icon_2.png",
                          @"home_tab_icon_3.png",
                          @"home_tab_icon_4.png",
                          @"home_tab_icon_5.png",
                          ];
    

    //03 选中图片
    CGFloat buttonWidth = kScreenWidth/imgNames.count;
    
    _tabArrowImageView = [[ThemeImageView  alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 49)];

    _tabArrowImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_tabArrowImageView];
    
    //04 每个button
    for (int i = 0; i<imgNames.count; i++) {
        NSString *name = imgNames[i];
    
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, 49)];
        button.normalImageName = name;
        button.tag = i;
        
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:button];
    }
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //01 创建子控制器
    [self _createSubviewController];
    //02 定制tabBar
    [self _customTabBar];
    //03 开定时器 ，请求未读消息
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定时器

- (void)timerAction:(NSTimer *)timer{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = appDelegate.sinaweibo;
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{



}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{

    CGFloat buttonWidth = kScreenWidth/5;
    
    
    if (_badgeView == nil) {
        _badgeView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth-32, 0, 32, 32)];
        _badgeView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeView];
        
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        [_badgeView addSubview:_badgeLabel];
        
    }
    
    NSNumber *status = result[@"status"];
    NSInteger count = [status integerValue];
    if (count > 0) {
        _badgeView.hidden = NO;
        
        if (count>99) {
            _badgeLabel.text = @"...";
        }else{
        
            _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
        }
    }else{
        _badgeView.hidden = YES;
    
    }
    
}





@end
