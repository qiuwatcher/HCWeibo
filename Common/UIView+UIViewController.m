//
//  UIView+UIViewController.m
//  HCWeibo
//
//  Created by gj on 15/12/14.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

//通过事件响应者链 查找下一个响应者

- (UIViewController *)viewController{
    
    UIResponder *nextResponder = self.nextResponder;
    
    while (nextResponder != nil) {
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    }
    
    
    return nil;
    
}


@end
