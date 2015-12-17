//
//  BaseViewController.m
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "BaseViewController.h"

#import "ThemeManager.h"

#import "MMDrawerController.h"


#import "UIViewController+MMDrawerController.h"

#import "AppDelegate.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"



@interface BaseViewController ()

@end

@implementation BaseViewController{
    UIView *_tipView;//加载提示视图
    MBProgressHUD *_hud;//三方加载提示视图

}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeDidChangeNotification object:nil
         ];
        
        
    }
    return self;

}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeDidChangeNotification object:nil
         ];
        
    }
    return self;

}

- (void)loadThemeResources{
    ThemeManager *manager = [ThemeManager shareInstance];
    //01 加载背景图片
    UIImage *bgImage = [manager getThemeImage: @"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadThemeResources];
    
    //如果是一级页面则设置导航按钮
    if (self.navigationController.viewControllers.count == 1) {
         [self setRootNavItem];
    }
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAction{
    NSLog(@"setAction");
    //01 获取mmDrawController
    MMDrawerController *mmDrawCtrl = self.mm_drawerController ;
    
    //>>01 方法一
    [mmDrawCtrl openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

    //>>02 方法二
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    mmDrawCtrl = (MMDrawerController*) appDelegate.window.rootViewController;
//    [mmDrawCtrl openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    
}
- (void)editAction{

    NSLog(@"editAction");
    MMDrawerController *mmDrawCtrl = self.mm_drawerController ;

    [mmDrawCtrl openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


- (void)setRootNavItem{
    //导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];

    //右边按钮
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
}

#pragma mark - 加载提示

- (void)showLoading:(BOOL)show{

    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-15, kScreenWidth, 30)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        //1 loading 视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        

        //2 label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"玩命加载中...";
        label.textColor = [UIColor blackColor];
        
        [label sizeToFit];//子适应大小
        [_tipView addSubview:label];
    
        //设置位置
        label.left = (kScreenWidth-label.width)/2;
        activityView.right = label.left-5;

    }
    
    if (show) {
        [self.view addSubview:_tipView];
    }else{
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }

    }

}



#pragma mark - 三方实现加载提示
- (void)showHUD:(NSString *)title{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_hud show:YES];
    _hud.labelText = title;
//    _hud.detailsLabelText = @"详情文字";
    _hud.dimBackground = YES;
}

- (void)hideHUD{

    [_hud hide:YES];

}
- (void)completeHUD:(NSString *)title{

    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    //自定义视图
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    //延迟隐藏
    [_hud hide:YES afterDelay:1];
    
    
    
    

}




@end
