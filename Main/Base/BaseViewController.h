//
//  BaseViewController.h
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showLoading:(BOOL)show;
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
- (void)completeHUD:(NSString *)title;
@end
