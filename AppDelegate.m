//
//  AppDelegate.m
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "RightViewController.h"
#import "LeftTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //00 创建新浪微博对象
    self.sinaweibo =  [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    
    //01 创建tabBarController
    MainTabBarController *tabCtrl = [[MainTabBarController alloc] init];
    
    
    //02 创建mmDrawerController
    
    //容器类控制器
    
    RightViewController *rightCtrl = [[RightViewController alloc] init];
    LeftTableViewController *leftCtrl = [[LeftTableViewController alloc] init];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:tabCtrl
                                             leftDrawerViewController:leftCtrl
                                             rightDrawerViewController:rightCtrl];
    
    //设置侧边栏宽度
    [drawerController setMaximumRightDrawerWidth:60.0];
    [drawerController setMaximumLeftDrawerWidth:100];
    
    //设置打开关闭手势
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置动画
    MMDrawerControllerDrawerVisualStateBlock block =  [MMDrawerVisualState swingingDoorVisualStateBlock];
    [drawerController setDrawerVisualStateBlock:block];
    //打开左边右边
    //[drawerController openDrawerSide:<#(MMDrawerSide)#> animated:<#(BOOL)#> completion:<#^(BOOL finished)completion#>];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    
    
    
    //03 读取沙盒中的存储的 TOKEN 信息
    [self readAuthData];

    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)readAuthData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"HCWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }

}


- (void)storeAuthData
{
    //存储到沙盒特定plist文件中。
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    //把字典存储到userDefaults里面
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"HCWeiboAuthData"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//新浪微博登录注销代理
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    NSLog(@"已经登录");
    [self storeAuthData];
}
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"已经注销");
    
}

@end
